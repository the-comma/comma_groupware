<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<!-- CSS -->
	<jsp:include page ="../views/nav/head-css.jsp"></jsp:include>	
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script> 
  <script defer src="<c:url value='/assets/js/chat.js'/>"></script>
  <script defer src="<c:url value='/assets/js/chatmodal.js'/>"></script>
  
<meta charset="UTF-8">
<title>temp 타이틀</title>
</head>
<body>
    <!-- 페이지 시작 -->
    <div class="wrapper">

	<!-- 사이드바 -->
	<jsp:include page ="../views/nav/sidenav.jsp"></jsp:include>
	
	<!-- 헤더 -->
	<jsp:include page ="../views/nav/header.jsp"></jsp:include>
	
        <div class="page-content">

            <div class="page-container">
            
            	<div class="container">
            	<!-- 본문 내용 -->
            	
            	<div class="row">
                    <div class="col-16">
                        

                            <div class="card-body">
                                <p class="text-muted">
	                            	<!-- 부가 설명 -->
                                </p>
                                <div class="row">
                                    <div class="col-lg-12">
                                       
											


                <div class="chat d-flex gap-2">
                    <div class="offcanvas-xxl offcanvas-start" tabindex="-1" id="chatUserList" aria-labelledby="chatUserListLabel">
                        <div id="chat-user-list" class="card collapse collapse-horizontal show">
                            <div class="chat-user-list">
                                <div class="card-body py-2 px-3 border-bottom">
                                    <div class="d-flex align-items-center gap-2 py-1">
                                        <div class="chat-users">
                                            <div class="avatar-lg chat-avatar-online">
                                                <img src="HTML/Admin/dist/assets/images/users/avatar-1.jpg" class="img-fluid rounded-circle" alt="Chris Keller">
                                            </div>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h5 class="mb-0">
                                                <a href="#!" class="text-reset lh-base">Nowak Helme (You)</a>
                                            </h5>
                                            <p class="mb-0 fs-13 text-muted">Admin</p>
                                        </div>
                                        <div class="dropdown lh-1">
                                            <a href="#" class="dropdown-toggle drop-arrow-none card-drop" data-bs-toggle="dropdown" aria-expanded="false">
                                                <iconify-icon icon="solar:settings-outline" class="align-middle"></iconify-icon>
                                            </a>
                                            <div class="dropdown-menu dropdown-menu-end">
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item"
                                                   data-bs-toggle="modal" 
                                                   data-bs-target="#scrollable-modal">
                                                    <i class="ti ti-user-plus me-1 fs-17 align-middle"></i>
                                                    <span class="align-middle">1대1 채팅 생성</span>
                                                </a>
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item">
                                                    <i class="ti ti-users-plus me-1 fs-17 align-middle"></i>
                                                    <span class="align-middle">New Group</span>
                                                </a>
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item">
                                                    <i class="ti ti-star me-1 fs-17 align-middle"></i>
                                                    <span class="align-middle">Favorites</span>
                                                </a>
                                                <!-- item-->
                                                <a href="javascript:void(0);" class="dropdown-item">
                                                    <i class="ti ti-archive me-1 fs-17 align-middle"></i>
                                                    <span class="align-middle">Archive Contacts</span>
                                                </a>
                                            </div>
                                        </div>
                                        <button type="button" class="flex-grow-0 btn btn-sm btn-icon btn-soft-danger d-xl-none" data-bs-dismiss="offcanvas" data-bs-target="#chatUserList" aria-label="Close">
                                            <i class="ti ti-x fs-20"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Contact list -->
                                <div class="d-flex flex-column">
                                    <div class="px-3 py-2">
                                        <div class="app-search py-1">
                                            <input type="text" class="form-control border-light bg-light bg-opacity-50 rounded-2" placeholder="Search something here...">
                                            <i class="app-search-icon ti ti-search text-muted fs-16"></i>
                                        </div>
                                    </div>

                                    <div class="users-list position-relative list-scroll" data-simplebar>
                                        <div class="d-flex align-items-center px-3 py-2 bg-body-secondary z-1">
                                            <iconify-icon icon="solar:pin-bold-duotone" class="fs-18 text-muted"></iconify-icon>
                                            <h5 class="mb-0 ms-1 fw-semibold fs-14">Pinned</h5>
                                        </div><!-- end chat-title -->

                                        <a href="javascript:void(0);" class="text-body d-block">
                                            <div class="chat-users">
                                                <div class="avatar-md chat-avatar-offline">
                                                    <img src="HTML/Admin/dist/assets/images/users/avatar-2.jpg" class="img-fluid rounded-circle" alt="Brandon Smith" />
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h5 class="m-0">
                                                        <span class="float-end text-muted fs-12">5:45am</span>
                                                        Brandon Smith
                                                    </h5>
                                                    <p class="mt-1 mb-0 text-muted lh-1">
                                                        <span class="w-25 float-end text-end"><span class="badge bg-danger-subtle text-danger">3</span></span>
                                                        <span class="w-75 d-inline-block text-truncate overflow-hidden fs-13">How
                                                            are you today?</span>
                                                    </p>
                                                </div>
                                            </div>
                                        </a><!-- end chat-user -->

                                        <a href="javascript:void(0);" class="text-body d-block">
                                            <div class="chat-users active">
                                                <div class="avatar-md chat-avatar-online">
                                                    <img src="HTML/Admin/dist/assets/images/users/avatar-5.jpg" class="img-fluid rounded-circle" alt="James Zavel" />
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h5 class="m-0">
                                                        <span class="float-end text-muted fs-12">4:30am</span>
                                                        James Zavel
                                                    </h5>
                                                    <p class="mt-1 mb-0 text-muted lh-1">
                                                        <span class="w-25 text-end float-end text-success"><i class="ti ti-checks"></i></span>
                                                        <span class="w-75 d-inline-block text-primary fw-semibold fs-13">typing...</span>
                                                    </p>
                                                </div>
                                            </div>
                                        </a><!-- end chat-user -->

                                        <a href="javascript:void(0);" class="text-body d-block">
                                            <div class="chat-users">
                                                <div class="avatar-md chat-avatar-online">
                                                    <img src="HTML/Admin/dist/assets/images/users/avatar-8.jpg" class="img-fluid rounded-circle" alt="Maria Lopez" />
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h5 class="m-0">
                                                        <span class="float-end text-muted fs-12">6:12pm</span>
                                                        Maria Lopez
                                                    </h5>
                                                    <p class="mt-1 mb-0 text-muted lh-1">
                                                        <span class="w-25 float-end text-end"><span class="badge bg-danger-subtle text-danger">1</span></span>
                                                        <span class="w-75 d-inline-block text-truncate overflow-hidden fs-13">How
                                                            are you today?</span>
                                                    </p>
                                                </div>
                                            </div>
                                        </a><!-- end chat-user -->

                                        <a href="javascript:void(0);" class="text-body d-block">
                                            <div class="chat-users">
                                                <div class="avatar-md chat-avatar-offline">
                                                    <div class="h-100 w-100 rounded-circle bg-info text-white d-flex align-items-center justify-content-center">
                                                        <span class="fw-semibold">OD</span>
                                                    </div>
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h5 class="m-0">
                                                        <span class="float-end text-muted fs-12">6:12pm</span>
                                                        Osen Discussion
                                                    </h5>
                                                    <p class="mt-1 mb-0 text-muted lh-1">
                                                        <span class="w-75 d-inline-block text-truncate overflow-hidden fs-13">JS
                                                            Developer's Come in office?</span>
                                                    </p>
                                                </div>
                                            </div>
                                        </a><!-- end chat-user -->

									
										<c:forEach var="chatList" items="${chatRoomList}"> 

                                        <div class="d-flex align-items-center px-3 py-2 bg-body-secondary position-sticky top-0 z-1">
                                            <iconify-icon icon="solar:chat-line-bold-duotone" class="fs-18 text-muted"></iconify-icon>
                                            <h5 class="mb-0 ms-1 fw-semibold fs-14">All Messages</h5>
                                        </div><!-- end chat-title -->

                                          <a href="#" 
									     class="text-body d-block js-room"
									     data-room-id="${chatList.chat_room_id}"     <%-- 또는 ${chat.chatRoomId} : 프로젝트 DTO 이름에 맞추세요 --%>
									     data-title="${chatList.display_name}">      <%-- 또는 ${chat.displayName} --%>
	                                            <div class="chat-users">
                                                <div class="avatar-md chat-avatar-online">
                                                    <img src="HTML/Admin/dist/assets/images/users/avatar-3.jpg" class="img-fluid rounded-circle" alt="Brandon Smith" />
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h5 class="m-0">
                                                        <span class="float-end text-muted fs-12">${chatList.last_time}</span>
                                                        ${chatList.display_name}
                                                    </h5>
                                                    <p class="mt-1 mb-0 text-muted lh-1">
                                                        <span class="w-75 d-inline-block text-truncate overflow-hidden fs-13">${chatList.last_message}</span>
                                                    </p>
                                                </div>
                                            </div>
                                        </a><!-- end chat-user -->
                                        
                                         </c:forEach> 
                                        

                                        
                                        <a href="javascript:void(0);" class="text-body d-block">
                                            <div class="chat-users">
                                                <div class="avatar-md chat-avatar-online">
                                                    <img src="HTML/Admin/dist/assets/images/users/avatar-6.jpg" class="img-fluid rounded-circle" alt="Brandon Smith" />
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h5 class="m-0">
                                                        <span class="float-end text-muted fs-12">Tue</span>
                                                        Louis Moller
                                                    </h5>
                                                    <p class="mt-1 mb-0 text-muted lh-1">
                                                        <span class="w-25 float-end text-end"><span class="badge bg-danger-subtle text-danger">1</span></span>
                                                        <span class="w-75 d-inline-block text-truncate overflow-hidden fs-13">Are
                                                            you free for 15 min?</span>
                                                    </p>
                                                </div>
                                            </div>
                                        </a><!-- end chat-user -->


                                    </div>
                                </div>
                                <!-- End Contact list -->
                            </div>
                        </div>
                    </div>

                    <div class="card chat-content">
                        <div class="card-header py-2 px-3 border-bottom">
                            <div class="d-flex align-items-center justify-content-between py-1">
                                <div class="d-flex align-items-center gap-2">

                                    <a href="#" class="btn btn-sm btn-icon btn-soft-primary d-none d-xl-flex me-2" data-bs-toggle="collapse" data-bs-target="#chat-user-list" aria-expanded="true">
                                        <i class="ti ti-chevrons-left fs-20"></i>
                                    </a>

                                    <button class="btn btn-sm btn-icon btn-ghost-light text-dark d-xl-none d-flex" type="button" data-bs-toggle="offcanvas" data-bs-target="#chatUserList" aria-controls="chatUserList">
                                        <i class="ti ti-menu-2 fs-20"></i>
                                    </button>

                                    <img src="HTML/Admin/dist/assets/images/users/avatar-5.jpg" class="avatar-lg rounded-circle" alt="">

                                    <div>
                                        <h5 class="my-0 lh-base">
                                            <a href="#" class="text-reset">James Zavel</a>
                                        </h5>
                                        <p class="mb-0 text-muted">
                                            <small class="ti ti-circle-filled text-success"></small> Active
                                        </p>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center gap-2">
                                    <a href="javascript: void(0);" class="btn btn-sm btn-icon btn-ghost-light d-none d-xl-flex" data-bs-toggle="modal" data-bs-target="#userCall" data-bs-toggle="tooltip" data-bs-placement="top" title="Voice Call">
                                        <i class="ti ti-phone-call fs-20"></i>
                                    </a>
                                    <a href="javascript: void(0);" class="btn btn-sm btn-icon btn-ghost-light d-none d-xl-flex" data-bs-toggle="modal" data-bs-target="#userVideoCall" data-bs-toggle="tooltip" data-bs-placement="top" title="Video Call">
                                        <i class="ti ti-video fs-20"></i>
                                    </a>

                                    <a href="javascript: void(0);" class="btn btn-sm btn-icon btn-ghost-light d-xl-flex">
                                        <i class="ti ti-info-circle fs-20"></i>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div>
                            <div class="chat-scroll p-3" data-simplebar data-apps-chat="messages-scroll-wrapper">
                                <ul class="chat-list" data-apps-chat="messages-list">


                                    <li class="chat-group odd" id="odd-4">
                                        <img src="HTML/Admin/dist/assets/images/users/avatar-1.jpg" class="avatar-sm rounded-circle" alt="avatar-1" />

                                        <div class="chat-body">
                                            <div>
                                                <h6 class="d-inline-flex">You.</h6>
                                                <h6 class="d-inline-flex text-muted">10:19pm</h6>
                                            </div>

                                            <div class="chat-message">
                                                <p>3pm works for me 👍. Absolutely, let's dive into the presentation
                                                    format. It'd be fantastic to wrap that up today. I'm attaching
                                                    last year's format and assets here for reference.</p>

                                                <div class="chat-actions dropdown">
                                                    <button class="btn btn-sm btn-link" data-bs-toggle="dropdown" aria-expanded="false">
                                                        <i class="ti ti-dots-vertical"></i>
                                                    </button>

                                                    <div class="dropdown-menu">
                                                        <a class="dropdown-item" href="#"><i class="ti ti-copy fs-14 align-text-top me-1"></i>
                                                            Copy Message</a>
                                                        <a class="dropdown-item" href="#"><i class="ti ti-edit-circle fs-14 align-text-top me-1"></i>
                                                            Edit</a>
                                                        <a class="dropdown-item" href="#" data-dismissible="#odd-4"><i class="ti ti-trash fs-14 align-text-top me-1"></i>Delete</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>



                            <div class="p-3 border-top position-sticky bottom-0 w-100 mb-0">
							<!-- 로그인 사용자ID/엔드포인트/초기 방ID(없으면 공백) 전달 -->
							<div id="chat-root"
					         	 data-user-id="<c:out value='${loginEmp.username}' default='0'/>"
    							 data-user-name="<c:out value='${loginEmp.empName}'   default='Me'/>"
							     data-room-id="<c:out value='${initRoomId}' default='0'/>"             <%-- 선택: 처음 열 방 --%>
							     data-ws-endpoint="<c:url value='/stomp/chat'/>"
							     data-pub-dest="/pub/chat/send"
							     data-sub-prefix="/sub/room."
							     data-avatar-me="<c:url value='/HTML/Admin/dist/assets/images/users/avatar-1.jpg'/>"
    							 data-avatar-user="<c:url value='/HTML/Admin/dist/assets/images/users/avatar-5.jpg'/>">
							     
							     </div>
							
							<!-- 메시지 입력 -->
							<form id="chat-form" class="d-flex align-items-center gap-1">
							  <button type="button" class="btn btn-icon btn-soft-warning">😊</button>
                               <input type="text" name="message" id="text" class="form-control" placeholder="Type Message..." required>
                              
							  <button type="submit" class="btn btn-icon btn-success chat-send"><i class='ti ti-send'></i></button>
							</form>
							
                            </div>
                        </div>
                    </div>
                </div>
            </div> <!-- container -->
											

                                   
                                    </div> <!-- end col -->
                                </div>
                                <!-- end row-->
                            </div> <!-- end card-body -->
                        
                    </div><!-- end col -->
                </div><!-- end row -->
            	
            	
            	<!-- 본문 내용 끝 -->
            
            	</div><!-- container 끝 -->
            	
            	<!-- 푸터 -->
            	<jsp:include page ="../views/nav/footer.jsp"></jsp:include>
            	
            </div><!-- page-container 끝 -->
            
       	</div><!-- page-content 끝 -->
       	
   </div><!-- wrapper 끝 -->
       												<!-- 모달 -->
											<div class="modal fade" id="scrollable-modal" tabindex="-1" role="dialog"
							                    aria-labelledby="scrollableModalTitle" aria-hidden="true">
							                    
																			                    <!-- 1:1 채팅 생성 폼 (숨김) -->
												<form id="create1to1Form" action="<c:url value='/chat/rooms/one-to-one'/>" method="post" class="d-none">
												  <!-- 미리보기는 안 써도 되지만, 구조 유지용으로 둠 -->
												  <div id="targetList"></div>
												  <!-- 여기 hidden input이 들어간다 -->
												  <div id="targetListBox"></div>
												
												</form>
							                    
							                    <div class="modal-dialog modal-dialog-scrollable" role="document">
							                        <div class="modal-content">
							                            <div class="modal-header">
							                                <h4 class="modal-title" id="scrollableModalTitle">1대1 채팅방 생성</h4>
							                                <button type="button" class="btn-close" data-bs-dismiss="modal"
							                                    aria-label="Close"></button>
							                            </div>
							                            <div class="modal-body">
							                            	<label for="deptTeam" class="form-label">부서/팀</label>
							                                <select class="form-control" id="deptTeam" name="deptTeam">
							                                	<option value="">부서/팀 선택</option>
							                                	<c:if test="${deptTeamList != null}">
							                                		<c:forEach items="${deptTeamList}" var="dept">
							                                			<option value="${dept.teamName}">${dept.deptName}/${dept.teamName}</option>
													                </c:forEach>
							                                	</c:if>
							                                </select>
							                                <br>
							                                <label for="empTable" class="form-label">사원</label>
							                                <table id="empTable" class="form-table">
							                                	<thead id="empTableHead">
							                                	</thead>
							                                	<tbody id="empList" name="empList">
							                                	</tbody>
							                                </table>	 
							                                <br>
							                                <label for="memberList" class="form-label">참여자</label>
							                                <div class="choices" data-type="text">
							                                	<div class="choices__inner">
							                                		<input readonly="readonly" class="form-control choices__input" id="choices-text-remove-button" data-choices="" data-choices-limit="3" data-choices-removeitem="" type="text" value="Task-1" hidden="" tabindex="-1" data-choice="active">
							                                			<div id="memberList" class="choices__list choices__list--multiple">
							                                			<!-- 아이템 들어가는 영역 -->

							                                			</div>
							                                		<input type="search" class="choices__input choices__input--cloned" autocomplete="off" autocapitalize="off" spellcheck="false" aria-autocomplete="list" aria-label="Set limit values with remove button" style="min-width: 1ch; width: 1ch;">
						                                		</div>
						                                		
						                                		<div class="choices__list choices__list--dropdown" aria-expanded="false">
							                                		<div class="choices__list" aria-multiselectable="true" role="listbox">
							                                		</div>
						                                		</div>
					                                		</div>                           
							                                <br>
							                                <br>
							                            </div>
							                            <div class="modal-footer">
							                                <button type="button" class="btn btn-outline-danger"
							                                    data-bs-dismiss="modal">취소</button>
							                                <button type="button" class="btn btn-outline-success" id="modalBtn">등록</button>
							                            </div>
							                            
							        
							                        </div><!-- /.modal-content -->
							                    </div><!-- /.modal-dialog -->
							                </div><!-- /.modal -->
   <!-- 자바 스크립트 -->
   <jsp:include page ="../views/nav/javascript.jsp"></jsp:include>
</body>
<script type="text/javascript">


</script>
</html>