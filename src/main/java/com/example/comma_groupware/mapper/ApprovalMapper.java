package com.example.comma_groupware.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ApprovalMapper {
    Map<String, Object> selectMyCurrentDeptInfo(int empId);
    int countFilesByDoc(int approvalDocumentId);
    Integer selectStep1Approver(Map<String, Object> param);
    Integer selectStep2ApproverForVacation();
    Integer selectStep2ApproverForExpense();

    int insertApprovalDocument(Map<String, Object> param);
    int insertRequestVacation(Map<String, Object> param);
    int insertRequestExpense(Map<String, Object> param);

    int insertApprovalLine(Map<String, Object> params);

    List<Map<String, Object>> selectMyDocuments(Map<String, Object> param);

    List<Map<String, Object>> selectMyTodoApprovalLines(int empId);
    List<Map<String, Object>> selectMyDoneApprovalLines(int empId);


    Map<String, Object> selectApprovalLineById(int approvalLineId);

    Map<String, Object> selectDocumentDetail(int approvalDocumentId);
    Map<String, Object> selectVacationDetail(int approvalDocumentId);
    Map<String, Object> selectExpenseDetail(int approvalDocumentId);
    List<Map<String, Object>> selectApprovalLinesByDoc(int approvalDocumentId);

    int updateApprovalLineStatus(Map<String, Object> param);
    int insertRejectReason(Map<String, Object> param);

    int updateDocumentStatus(Map<String, Object> param);
    boolean isAllLinesApproved(int approvalDocumentId);
    
    int ensureAnnualLeaveRow(int empId);    
    int tryDecrementAnnualLeaveIfEnough(Map<String, Object> param);
    int countOverlappingApprovedVacations(Map<String,Object> param);

    int insertFile(Map<String, Object> param);

    List<Map<String, Object>> selectVacationCodes();
    List<Map<String, Object>> selectExpenseCodes();

    Double selectAnnualLeave(int empId);

    String selectExpenseTitleById(@Param("expenseId") int expenseId);
    String selectVacationTitleById(@Param("vacationId") int vacationId);

    Map<String, Object> selectDocOwnerAndStatus(@Param("approvalDocumentId") int approvalDocumentId);
    int countNonPendingLines(@Param("approvalDocumentId") int approvalDocumentId);

    int updateRequestVacation(Map<String, Object> p);
    int updateRequestExpense(Map<String, Object> p);

    int updateApprovalTitle(Map<String, Object> p);

    List<Map<String, Object>> selectFilesByDoc(int approvalDocumentId);
    Map<String, Object> selectFileById(int fileId);
    int deleteFileById(int fileId);

    int deleteFilesByDoc(int approvalDocumentId);
    int deleteApprovalLinesByDoc(int approvalDocumentId);
    int deleteRequestVacationByDoc(int approvalDocumentId);
    int deleteRequestExpenseByDoc(int approvalDocumentId);
    int deleteDocument(int approvalDocumentId);
    
    Integer selectNextApproverInTeam(Map<String,Object> param);
    Boolean existsApprovalLineForStep(Map<String,Object> param);
    Integer selectNextApproverInDept(Map<String,Object> param);
    
    Map<String, Object> selectMyActionableLineForDoc(Map<String, Object> param);
    int insertExpenseItems(Map<String,Object> p);                   // p: {approvalDocumentId, items(List<Map>)}
    List<Map<String,Object>> selectExpenseItemsByDoc(int approvalDocumentId);
    Map<String,Object> selectExpenseItemSumsByDoc(int approvalDocumentId); // {sumSupply,sumVat,sumTotal}
    int deleteExpenseItemsByDoc(int approvalDocumentId);
}