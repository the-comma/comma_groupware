package com.example.comma_groupware.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.comma_groupware.mapper.ApprovalMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ApprovalService {
    private final ApprovalMapper approvalMapper;

    @org.springframework.beans.factory.annotation.Value("${upload.path:./uploads}")
    private String uploadPath; 

    /* -------- 공통 유틸: 로그인 사원 ID만 알면 자동 결재선 구성 -------- */

    private int findStep1Approver(int writerEmpId) {
        Map<String, Object> p = new HashMap<>();
        p.put("empId", writerEmpId);
        Integer approver = approvalMapper.selectStep1Approver(p);
        if (approver == null) throw new IllegalStateException("1차 결재자 후보가 없습니다.");
        return approver;
    }

    private int findStep2Approver(String documentType) {
        if ("VACATION".equalsIgnoreCase(documentType)) {
            Integer approver = approvalMapper.selectStep2ApproverForVacation();
            if (approver == null) throw new IllegalStateException("2차(휴가) 결재자 후보가 없습니다.");
            return approver;
        } else if ("EXPENSE".equalsIgnoreCase(documentType)) {
            Integer approver = approvalMapper.selectStep2ApproverForExpense();
            if (approver == null) throw new IllegalStateException("2차(지출) 결재자 후보가 없습니다.");
            return approver;
        }
        throw new IllegalArgumentException("지원하지 않는 문서 유형: " + documentType);
    }

    /* -------- 생성 / 파일 -------- */
    private static int asInt(Object v) {
        if (v == null) return 0;
        if (v instanceof Number n) return n.intValue(); // BigInteger, Long, Integer 모두 OK
        return Integer.parseInt(String.valueOf(v));
    }
    
    @Transactional
    public int createVacationDocument(int writerEmpId,
                                      String title,
                                      String reason,
                                      int vacationId,
                                      String startDate, String endDate,
                                      int totalDays,
                                      List<MultipartFile> files) throws Exception {

        Map<String, Object> doc = new HashMap<>();
        doc.put("empId", writerEmpId);
        doc.put("title", title);
        doc.put("documentType", "VACATION");
        doc.put("reason", reason);
        doc.put("isFile", (files != null && !files.isEmpty()) ? 1 : 0);

        approvalMapper.insertApprovalDocument(doc);
        int approvalDocumentId = ((Number) doc.get("approvalDocumentId")).intValue();

        Map<String, Object> rv = new HashMap<>();
        rv.put("approvalDocumentId", approvalDocumentId);
        rv.put("vacationId", vacationId);
        rv.put("requestReason", reason);
        rv.put("startDate", startDate);
        rv.put("endDate", endDate);
        rv.put("totalDays", totalDays);
        approvalMapper.insertRequestVacation(rv);

        // 결재선 자동 지정
        int step1 = findStep1Approver(writerEmpId);
        int step2 = findStep2Approver("VACATION");

        Map<String, Object> line1 = Map.of(
                "approvalDocumentId", approvalDocumentId,
                "approverEmpId", step1,
                "step", 1
        );
        Map<String, Object> line2 = Map.of(
                "approvalDocumentId", approvalDocumentId,
                "approverEmpId", step2,
                "step", 2
        );
        approvalMapper.insertApprovalLine(new HashMap<>(line1));
        approvalMapper.insertApprovalLine(new HashMap<>(line2));

        // 파일 저장
        saveFiles(writerEmpId, approvalDocumentId, files);

        return approvalDocumentId;
    }

    @Transactional
    public int createExpenseDocument(int writerEmpId,
                                     String title,
                                     String reason,
                                     int expenseId,
                                     long amount,
                                     String expenseDate,
                                     List<MultipartFile> files) throws Exception {

        Map<String, Object> doc = new HashMap<>();
        doc.put("empId", writerEmpId);
        doc.put("title", title);
        doc.put("documentType", "EXPENSE");
        doc.put("reason", reason);
        doc.put("isFile", (files != null && !files.isEmpty()) ? 1 : 0);

        approvalMapper.insertApprovalDocument(doc);
        int approvalDocumentId = asInt(doc.get("approvalDocumentId"));

        Map<String, Object> re = new HashMap<>();
        re.put("approvalDocumentId", approvalDocumentId);
        re.put("expenseId", expenseId);
        re.put("requestReason", reason);
        re.put("amount", amount);
        re.put("expenseDate", expenseDate);
        approvalMapper.insertRequestExpense(re);

        int step1 = findStep1Approver(writerEmpId);
        int step2 = findStep2Approver("EXPENSE");

        Map<String, Object> line1 = Map.of(
                "approvalDocumentId", approvalDocumentId,
                "approverEmpId", step1,
                "step", 1
        );
        Map<String, Object> line2 = Map.of(
                "approvalDocumentId", approvalDocumentId,
                "approverEmpId", step2,
                "step", 2
        );
        approvalMapper.insertApprovalLine(new HashMap<>(line1));
        approvalMapper.insertApprovalLine(new HashMap<>(line2));

        saveFiles(writerEmpId, approvalDocumentId, files);

        return approvalDocumentId;
    }

    private void saveFiles(int uploaderEmpId, int refId, List<MultipartFile> files) throws Exception {
        if (files == null || files.isEmpty()) return;
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        for (MultipartFile mf : files) {
            if (mf.isEmpty()) continue;
            String origin = mf.getOriginalFilename();
            String ext = (origin != null && origin.contains(".")) ? origin.substring(origin.lastIndexOf('.') + 1) : "bin";
            String save = UUID.randomUUID().toString().replace("-", "");
            File dest = new File(dir, save);
            mf.transferTo(dest);

            Map<String, Object> f = new HashMap<>();
            f.put("size", mf.getSize());
            f.put("originName", origin);
            f.put("saveName", save);
            f.put("ext", ext);
            f.put("refId", refId);
            f.put("uploaderEmpId", uploaderEmpId);
            approvalMapper.insertFile(f);
        }
    }

    /* -------- 목록/조회 -------- */

    public List<Map<String,Object>> getMyDocuments(int empId, String status) {
        Map<String,Object> p = new HashMap<>();
        p.put("empId", empId);
        p.put("status", status);
        return approvalMapper.selectMyDocuments(p);
    }

    public Map<String,Object> getDocumentDetail(int approvalDocumentId) {
        Map<String,Object> doc = approvalMapper.selectDocumentDetail(approvalDocumentId);
        if (doc == null) return null;
        List<Map<String,Object>> lines = approvalMapper.selectApprovalLinesByDoc(approvalDocumentId);
        doc.put("lines", lines);

        String type = (String) doc.get("documentType");
        if ("VACATION".equalsIgnoreCase(type)) {
            doc.put("vacation", approvalMapper.selectVacationDetail(approvalDocumentId));
        } else if ("EXPENSE".equalsIgnoreCase(type)) {
            doc.put("expense", approvalMapper.selectExpenseDetail(approvalDocumentId));
        }
        return doc;
    }

    public List<Map<String,Object>> getMyTodoLines(int approverEmpId) {
        return approvalMapper.selectMyTodoApprovalLines(approverEmpId);
    }
    public List<Map<String,Object>> getMyDoneLines(int approverEmpId) {
        return approvalMapper.selectMyDoneApprovalLines(approverEmpId);
    }

    public List<Map<String,Object>> getVacationCodes() { return approvalMapper.selectVacationCodes(); }
    public List<Map<String,Object>> getExpenseCodes() { return approvalMapper.selectExpenseCodes(); }
    public Double getAnnualLeave(int empId) { return approvalMapper.selectAnnualLeave(empId); }

    /* -------- 결재(승인/반려) -------- */

    @Transactional
    public void approveLine(int approvalLineId, int approverEmpId) {
        Map<String,Object> line = approvalMapper.selectApprovalLineById(approvalLineId);
        if (line == null) throw new IllegalArgumentException("결재라인이 존재하지 않습니다.");

        Map<String,Object> up = new HashMap<>();
        up.put("approvalLineId", approvalLineId);
        up.put("approverEmpId", approverEmpId);
        up.put("status", "APPROVED");
        int updated = approvalMapper.updateApprovalLineStatus(up);
        if (updated == 0) throw new IllegalStateException("이미 처리되었거나 권한이 없습니다.");

        int docId = ((Number)line.get("approval_document_id")).intValue();

        // 모든 결재라인이 승인되면 문서 완료 처리
        boolean allApproved = approvalMapper.isAllLinesApproved(docId);
        if (allApproved) {
            Map<String,Object> d = Map.of("approvalDocumentId", docId, "status", "APPROVED");
            approvalMapper.updateDocumentStatus(new HashMap<>(d));

            // 휴가 문서면 연차 차감
            Map<String,Object> doc = approvalMapper.selectDocumentDetail(docId);
            if ("VACATION".equalsIgnoreCase((String)doc.get("documentType"))) {
                Map<String,Object> v = approvalMapper.selectVacationDetail(docId);
                int days = ((Number)v.getOrDefault("total_days", 0)).intValue();
                int writer = ((Number)doc.get("writerEmpId")).intValue();
                if (days > 0) {
                    Map<String,Object> dec = Map.of("empId", writer, "days", days);
                    approvalMapper.decrementAnnualLeave(new HashMap<>(dec));
                }
                // 캘린더 반영은 DB 트리거가 처리 (APPROVED로 바뀌면 VACATION 일정 Insert). :contentReference[oaicite:3]{index=3}
            }
        }
    }

    @Transactional
    public void rejectLine(int approvalLineId, int approverEmpId, String reason) {
        Map<String,Object> line = approvalMapper.selectApprovalLineById(approvalLineId);
        if (line == null) throw new IllegalArgumentException("결재라인이 존재하지 않습니다.");

        Map<String,Object> up = new HashMap<>();
        up.put("approvalLineId", approvalLineId);
        up.put("approverEmpId", approverEmpId);
        up.put("status", "REJECTED");
        int updated = approvalMapper.updateApprovalLineStatus(up);
        if (updated == 0) throw new IllegalStateException("이미 처리되었거나 권한이 없습니다.");

        Map<String,Object> rr = Map.of(
                "approvalLineId", approvalLineId,
                "rejectReason", reason == null ? "사유 미입력" : reason
        );
        approvalMapper.insertRejectReason(new HashMap<>(rr));

        int docId = ((Number)line.get("approval_document_id")).intValue();
        Map<String,Object> d = Map.of("approvalDocumentId", docId, "status", "REJECTED");
        approvalMapper.updateDocumentStatus(new HashMap<>(d));
        // 반려 시 즉시 문서 상태 'REJECTED' 전환, 2차에게는 노출되지 않음(라인이 PENDING이 아니게 됨)
    }
}
