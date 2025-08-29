package com.example.comma_groupware.service;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    private Path getUploadRoot() {
        try {
            Path root = Paths.get(uploadPath);
            if (!root.isAbsolute()) {
                root = Paths.get(System.getProperty("user.dir"))
                            .resolve(root).normalize().toAbsolutePath();
            }
            Files.createDirectories(root);
            return root;
        } catch (IOException e) {
            throw new IllegalStateException("업로드 경로 초기화 실패", e);
        }
    }
    /* -------- 공통 유틸: 로그인 사원 ID만 알면 자동 결재선 구성 -------- */
	 // 같은 팀에서 우선순위(2>3>5), 휴가중 제외, 결정적 선택
	    private Integer pickApproverInTeam(int writerEmpId, Integer excludeEmpId){
	        Map<String,Object> p = new HashMap<>();
	        p.put("writerEmpId", writerEmpId);
	        p.put("excludeEmpId", excludeEmpId);
	        return approvalMapper.selectNextApproverInTeam(p); // 없으면 null
	    }
	    // 부서기준 후보 선택
	    private Integer pickApproverInDept(int deptId, Integer excludeEmpId, Integer writerEmpId){
	        Map<String,Object> p = new HashMap<>();
	        p.put("deptId", deptId);
	        p.put("excludeEmpId", excludeEmpId);
	        p.put("writerEmpId", writerEmpId);
	        return approvalMapper.selectNextApproverInDept(p); // 없으면 null
	    }
	    
	    private Integer deptForStep2(String documentType){
	        if ("VACATION".equalsIgnoreCase(documentType)) return 2;
	        if ("EXPENSE".equalsIgnoreCase(documentType))  return 3;
	        return null; // 그 외는 필요 시 확장
	    }
    
    // =========================== 폼 상단에 표시할 내 부서/팀 ===========================
    public Map<String,Object> getMyDeptTeam(int empId){                 
        // returns {dept_id, dept_name, team_id, team_name}
        return approvalMapper.selectMyCurrentDeptInfo(empId);
    }
    
    /* -------- 생성 / 파일 -------- */
    // generated key 안전 변환
    private int asInt(Object o){
        if (o instanceof Number n) return n.intValue();
        return Integer.parseInt(String.valueOf(o));
    }
    
    @Transactional
    public int createVacationDocument(int empId, String _ignoredTitle,
                                      int vacationId, String startDate, String endDate, double totalDays,
                                      String emergencyContact, String handover, String vacationReason, 
                                      List<MultipartFile> files) throws Exception {
    	
    	// 카테고리명 서버에서 조회
        String vacTitle = approvalMapper.selectVacationTitleById(vacationId);
        if (vacTitle == null || vacTitle.isBlank()) vacTitle = "휴가";
        String title = "[" + vacTitle + "] " + startDate + " ~ " + endDate + " 휴가신청";
        
        // 1) 문서 헤더 저장 (reason 없음)
        Map<String,Object> doc = new HashMap<>();
        doc.put("empId", empId);
        doc.put("title", title);
        doc.put("documentType", "VACATION");
        doc.put("isFile", (files != null && !files.isEmpty()) ? 1 : 0);
        approvalMapper.insertApprovalDocument(doc);
        int approvalDocumentId = asInt(doc.get("approvalDocumentId"));

        // 2) 휴가 상세 저장 (요청별 상세 컬럼으로)
        Map<String,Object> rv = new HashMap<>();
        rv.put("approvalDocumentId", approvalDocumentId);
        rv.put("vacationId", vacationId);
        rv.put("startDate", startDate);
        rv.put("endDate", endDate);
        rv.put("totalDays", totalDays);            
        rv.put("emergencyContact", emergencyContact); 
        rv.put("handover", handover);              
        rv.put("vacationReason", vacationReason);              
        approvalMapper.insertRequestVacation(rv);

        //결재선 자동 구성 로직 
        createApprovalLinesFor("VACATION", approvalDocumentId, empId);

        // 4) 파일 저장 (업로드 경로 생성 포함)
        saveFiles(empId, approvalDocumentId, files);
        return approvalDocumentId;
    }
    
    
    /* —— 지출 생성 —— */
    @Transactional
    public int createExpenseDocument(int empId, String _ignoredTitle,
                                     int expenseId, long amount, String expenseDate,
                                     String vendor, String payMethod, String bankInfo, String expenseReason, 
                                     List<MultipartFile> files) throws Exception {
    	
    	String expTitle = approvalMapper.selectExpenseTitleById(expenseId);
        if (expTitle == null || expTitle.isBlank()) expTitle = "지출";
        String vendorPart = (vendor == null || vendor.isBlank()) ? "" : (vendor + " ");
        String title = "[" + expTitle + "] " + vendorPart + "지출결의";
        
        // 1) 문서 헤더 저장 (reason 없음)
        Map<String,Object> doc = new HashMap<>();
        doc.put("empId", empId);
        doc.put("title", title);
        doc.put("documentType", "EXPENSE");
        doc.put("isFile", (files != null && !files.isEmpty()) ? 1 : 0);
        approvalMapper.insertApprovalDocument(doc);
        int approvalDocumentId = asInt(doc.get("approvalDocumentId"));

        // 2) 지출 상세 저장 (라인 없이 대표 필드만)
        Map<String,Object> re = new HashMap<>();
        re.put("approvalDocumentId", approvalDocumentId);
        re.put("expenseId", expenseId);
        re.put("amount", amount);               // -> total_amount
        re.put("expenseDate", expenseDate);
        re.put("vendor", vendor);
        re.put("payMethod", payMethod);
        re.put("bankInfo", bankInfo);
        re.put("expenseReason", expenseReason);
        approvalMapper.insertRequestExpense(re);

        // 자동 결재선 생성 쓰면
         createApprovalLinesFor("EXPENSE", approvalDocumentId, empId);

        // 4) 파일 저장(경로 자동 생성)
        saveFiles(empId, approvalDocumentId, files);
        return approvalDocumentId;
    }

    private void saveFiles(int uploaderEmpId, int refId, List<MultipartFile> files) throws Exception {
        if (files == null || files.isEmpty()) return;
        Path root = getUploadRoot();
        for (MultipartFile mf : files) {
            if (mf.isEmpty()) continue;
            String origin = mf.getOriginalFilename();
            String ext = (origin != null && origin.contains(".")) ? origin.substring(origin.lastIndexOf('.') + 1) : "bin";
            String save = java.util.UUID.randomUUID().toString().replace("-", "");
            try (InputStream in = mf.getInputStream()) {
                Files.copy(in, root.resolve(save), REPLACE_EXISTING);
            }
            Map<String,Object> f = new HashMap<>();
            f.put("size", mf.getSize());
            f.put("originName", origin);
            f.put("saveName", save);
            f.put("ext", ext);
            f.put("refId", refId);
            f.put("uploaderEmpId", uploaderEmpId);
            approvalMapper.insertFile(f);
        }
    }
    
    /* —— 결재선 생성 (프로젝트 룰에 맞게 구현) —— */
    private void createApprovalLinesFor(String documentType, int docId, int writerEmpId) {
        Integer step1 = pickApproverInTeam(writerEmpId, null);
        if (step1 == null) throw new IllegalStateException("1차 결재자 후보가 없습니다. (팀 내 부장/과장/대리 부재 또는 전원 휴가)");

        Map<String, Object> p1 = new HashMap<>();
        p1.put("approvalDocumentId", docId);
        p1.put("empId", step1);
        p1.put("approvalStep", 1);
        approvalMapper.insertApprovalLine(p1);
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
        // 첨부 리스트
        doc.put("files", approvalMapper.selectFilesByDoc(approvalDocumentId));
        return doc;
    }
    
    public Map<String, Object> getMyDeptInfo(int empId) {
        return approvalMapper.selectMyCurrentDeptInfo(empId);
    }
    
    public List<Map<String,Object>> getMyTodoLines(int approverEmpId) {
        return approvalMapper.selectMyTodoApprovalLines(approverEmpId);
    }
    public List<Map<String,Object>> getMyDoneLines(int approverEmpId) {
        return approvalMapper.selectMyDoneApprovalLines(approverEmpId);
    }
    
    public Map<String,Object> getMyActionableLineForDoc(int empId, int docId){
        Map<String,Object> p = new HashMap<>();
        p.put("empId", empId);
        p.put("docId", docId);
        return approvalMapper.selectMyActionableLineForDoc(p);
    }

    public Map<String,Object> getFileMeta(int fileId){
        return approvalMapper.selectFileById(fileId);
    }
    
    public List<Map<String,Object>> getVacationCodes() { return approvalMapper.selectVacationCodes(); }
    public List<Map<String,Object>> getExpenseCodes() { return approvalMapper.selectExpenseCodes(); }
    
    public Double getAnnualLeave(int empId) { return approvalMapper.selectAnnualLeave(empId); }

    /* -------- 결재(승인/반려) -------- */

    @Transactional
    public void approveLine(int approvalLineId, int approverEmpId) {
        Map<String,Object> line = approvalMapper.selectApprovalLineById(approvalLineId);
        if (line == null) throw new IllegalArgumentException("결재라인이 존재하지 않습니다.");

        // 0) 현재 라인 승인
        Map<String,Object> up = new HashMap<>();
        up.put("approvalLineId", approvalLineId);
        up.put("approverEmpId", approverEmpId);
        up.put("status", "APPROVED");
        int updated = approvalMapper.updateApprovalLineStatus(up);
        if (updated == 0) throw new IllegalStateException("이미 처리되었거나 권한이 없습니다.");

        int docId    = ((Number)line.get("approval_document_id")).intValue();
        int thisStep = ((Number)line.get("approval_step")).intValue();

        // 1) 문서/작성자/문서유형 먼저 확보 (← docType 선언을 가장 위로 끌어올림)
        Map<String,Object> doc = approvalMapper.selectDocumentDetail(docId);
        if (doc == null) throw new IllegalStateException("문서가 없습니다.");
        String docType = String.valueOf(doc.get("documentType"));  // ← 여기서 반드시 선언
        int writer     = ((Number)doc.get("writerEmpId")).intValue();

        // 2) 1차가 방금 승인되었으면, 지금 시점에 2차 라인을 '문서유형별 부서' 기준으로 생성
        if (thisStep == 1) {
            boolean hasStep2 = Boolean.TRUE.equals(
                approvalMapper.existsApprovalLineForStep(Map.of("docId", docId, "step", 2))
            );
            if (!hasStep2) {
                Integer deptId   = deptForStep2(docType); // VACATION→2(인사), EXPENSE→3(경영)
                Integer step1Emp = ((Number)line.get("emp_id")).intValue();

                Integer step2 = null;
                if (deptId != null) {
                    step2 = pickApproverInDept(deptId, step1Emp, writer); // 부서 기준: 부장→과장→대리, OOO 제외, 결정적
                } else {
                    // 문서유형 매핑이 없으면 필요 시 팀 기준으로 fallback 가능:
                    // step2 = pickApproverInTeam(writer, step1Emp);
                }

                if (step2 != null) {
                    Map<String,Object> p2 = new HashMap<>();
                    p2.put("approvalDocumentId", docId);
                    p2.put("empId", step2);
                    p2.put("approvalStep", 2);
                    approvalMapper.insertApprovalLine(p2);
                    // 2차가 방금 생성되었으므로 최종 처리는 2차 승인 때 한다.
                    return;
                }
                // 후보 전무 → 1스텝 체계로 간주하고 아래 최종 승인 로직으로 진행
            }
        }

        // 3) 모든 라인이 승인되었는지 확인 (2차이거나, 2차가 없어서 1차가 곧바로 최종일 수도 있음)
        boolean allApproved = approvalMapper.isAllLinesApproved(docId);
        if (!allApproved) return;

        // 4) 최종 처리
        if ("VACATION".equalsIgnoreCase(docType)) {
            Map<String,Object> v = approvalMapper.selectVacationDetail(docId);
            if (v == null) throw new IllegalStateException("휴가 상세가 없습니다.");

            String s = String.valueOf(v.get("startDate"));
            String e = String.valueOf(v.get("endDate"));
            int vacationId = ((Number)v.get("vacationId")).intValue();
            double days = ((Number)v.getOrDefault("totalDays", 0)).doubleValue();

            // 승인된 휴가와 겹침 최종 체크
            Map<String,Object> ov = new HashMap<>();
            ov.put("empId", writer);
            ov.put("startDate", s);
            ov.put("endDate", e);
            ov.put("excludeDocId", docId);
            int overlap = approvalMapper.countOverlappingApprovedVacations(ov);
            if (overlap > 0) {
                throw new IllegalStateException("이미 승인된 휴가와 기간이 겹쳐 승인할 수 없습니다.");
            }

            // 연차(5)/반차(6)만 잔여연차 검증 + 조건부 차감
            if (vacationId == 5 || vacationId == 6) {
                Double remain = approvalMapper.selectAnnualLeave(writer);
                double remainVal = (remain == null ? 0.0 : remain);
                if (days > remainVal) {
                    throw new IllegalStateException("잔여연차 부족으로 승인할 수 없습니다. (요청: " + days + "일, 잔여: " + remainVal + "일)");
                }
                int affected = approvalMapper.tryDecrementAnnualLeaveIfEnough(new HashMap<>(Map.of(
                    "empId", writer, "days", days
                )));
                if (affected == 0) {
                    throw new IllegalStateException("잔여연차 부족 또는 경합으로 승인할 수 없습니다.");
                }
            }
        }

        // 5) 최종 승인 상태 반영
        approvalMapper.updateDocumentStatus(new HashMap<>(Map.of(
            "approvalDocumentId", docId, "status", "APPROVED"
        )));
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
    // 승인 전(=모든 라인이 PENDING) + 내가 작성자 인지
    public boolean canEditOrDelete(int docId, int empId) {
        Map<String,Object> d = approvalMapper.selectDocumentDetail(docId);
        if (d == null) return false;
        int writer = ((Number)d.get("writerEmpId")).intValue();
        if (writer != empId) return false;
        String status = (String)d.get("status");
        if ("APPROVED".equals(status) || "REJECTED".equals(status)) return false;
        int progressed = approvalMapper.countNonPendingLines(docId);
        return progressed == 0;
    }
    
    // =========================== 수정/삭제 허용 여부 공통 체크 ===========================
    private void assertEditable(int approvalDocumentId, int empId){     
        Map<String,Object> doc = approvalMapper.selectDocOwnerAndStatus(approvalDocumentId);
        if (doc == null) throw new IllegalArgumentException("문서가 없습니다.");
        int owner = ((Number)doc.get("empId")).intValue();
        if (owner != empId) throw new IllegalStateException("수정/삭제 권한이 없습니다.");

        String status = String.valueOf(doc.get("status")); // IN_PROGRESS 이여야 함
        int decided = approvalMapper.countNonPendingLines(approvalDocumentId);
        if (!"IN_PROGRESS".equalsIgnoreCase(status) || decided > 0) {
            throw new IllegalStateException("승인 진행 중이거나 완료된 문서는 수정/삭제할 수 없습니다.");
        }
    }
    
    // =========================== 휴가 문서 수정 ===========================
    @Transactional
    public void updateVacationDocument(
        int approvalDocumentId, int empId,
        int vacationId, String startDate, String endDate, double totalDays,
        String emergencyContact, String handover, String vacationReason,
        List<MultipartFile> addFiles, List<Integer> deleteFileIds
    ) throws Exception {
        assertEditable(approvalDocumentId, empId);

        // 1) 상세 수정
        Map<String,Object> p = new HashMap<>();
        p.put("approvalDocumentId", approvalDocumentId);
        p.put("vacationId", vacationId);
        p.put("startDate", startDate);
        p.put("endDate", endDate);
        p.put("totalDays", totalDays);
        p.put("emergencyContact", emergencyContact);
        p.put("handover", handover);
        p.put("vacationReason", vacationReason);
        approvalMapper.updateRequestVacation(p);

        // 2) 제목 재생성
        String vacTitle = approvalMapper.selectVacationTitleById(vacationId);
        if (vacTitle == null || vacTitle.isBlank()) vacTitle = "휴가";
        String title = "[" + vacTitle + "] " + startDate + " ~ " + endDate + " 휴가신청";

        // 3) 파일 삭제 (체크된 것만)
        if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
            Path root = getUploadRoot();
            for (Integer fid : deleteFileIds) {
                Map<String,Object> fr = approvalMapper.selectFileById(fid);
                if (fr != null && ((Number)fr.get("refId")).intValue() == approvalDocumentId) {
                    try {
                        Files.deleteIfExists(root.resolve(String.valueOf(fr.get("saveName"))));
                    } catch(Exception ignore){}
                    approvalMapper.deleteFileById(fid);
                }
            }
        }

        // 4) 파일 추가 (있을 때만)
        saveFiles(empId, approvalDocumentId, addFiles);

        // 5) is_file 정확 갱신 = DB 실제 개수 기반
        int fileCount = approvalMapper.countFilesByDoc(approvalDocumentId);
        int hasFiles  = fileCount > 0 ? 1 : 0;

        Map<String,Object> up = Map.of(
            "approvalDocumentId", approvalDocumentId,
            "title", title,
            "isFile", hasFiles
        );
        approvalMapper.updateApprovalTitle(new HashMap<>(up));
    }

    // =========================== 지출 문서 수정 ===========================
    @Transactional
    public void updateExpenseDocument(                                
        int approvalDocumentId, int empId,
        int expenseId, long amount, String expenseDate,
        String vendor, String payMethod, String bankInfo, String expenseReason,
        List<MultipartFile> addFiles, List<Integer> deleteFileIds
    ) throws Exception {
        assertEditable(approvalDocumentId, empId);

        Map<String,Object> p = new HashMap<>();
        p.put("approvalDocumentId", approvalDocumentId);
        p.put("expenseId", expenseId);
        p.put("amount", amount);
        p.put("expenseDate", expenseDate);
        p.put("vendor", vendor);
        p.put("payMethod", payMethod);
        p.put("bankInfo", bankInfo);
        p.put("expenseReason", expenseReason);
        approvalMapper.updateRequestExpense(p);

        // 제목 재생성
        String expTitle = approvalMapper.selectExpenseTitleById(expenseId);
        if (expTitle == null || expTitle.isBlank()) expTitle = "지출";
        String vendorPart = (vendor == null || vendor.isBlank()) ? "" : (vendor + " ");
        String title = "[" + expTitle + "] " + vendorPart + "지출결의";

        // 파일 삭제
        if (deleteFileIds != null) {
            Path root = getUploadRoot(); // ★ 추가
            for(Integer fid: deleteFileIds){
                Map<String,Object> fr = approvalMapper.selectFileById(fid);
                if (fr != null && ((Number)fr.get("refId")).intValue() == approvalDocumentId) {
                    try { Files.deleteIfExists(root.resolve(String.valueOf(fr.get("saveName")))); } catch(Exception ignore){}
                    approvalMapper.deleteFileById(fid);
                }
            }
        }

        // 파일 추가
        saveFiles(empId, approvalDocumentId, addFiles);

        int fileCount = approvalMapper.countFilesByDoc(approvalDocumentId);
        int hasFiles  = fileCount > 0 ? 1 : 0;
        Map<String,Object> up = Map.of(
            "approvalDocumentId", approvalDocumentId,
            "title", title,
            "isFile", hasFiles
        );
        
        approvalMapper.updateApprovalTitle(new HashMap<>(up));
    }

    // =========================== 문서 삭제(승인 전) ===========================
    @Transactional
    public void deleteDocument(int approvalDocumentId, int empId) {
        assertEditable(approvalDocumentId, empId);

        Path root = getUploadRoot();            // 이 메서드도 체크예외 안 던지게 구현
        List<Map<String,Object>> files = approvalMapper.selectFilesByDoc(approvalDocumentId);
        for (Map<String,Object> fr : files){
            try {
                Files.deleteIfExists(root.resolve(String.valueOf(fr.get("saveName"))));
            } catch (Exception ignore) {}
        }
        approvalMapper.deleteFilesByDoc(approvalDocumentId);
        approvalMapper.deleteApprovalLinesByDoc(approvalDocumentId);
        approvalMapper.deleteRequestVacationByDoc(approvalDocumentId);
        approvalMapper.deleteRequestExpenseByDoc(approvalDocumentId);
        approvalMapper.deleteDocument(approvalDocumentId);
    }
}
