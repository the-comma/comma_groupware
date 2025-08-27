<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<!-- Sidenav Menu Start -->
<div class="sidenav-menu">

    <!-- Brand Logo -->
    <a href="index.html" class="logo">
        <span class="logo-light">
            <span class="logo-lg"><img src="/HTML/Admin/dist/assets/images/logo.png" alt="logo"></span>
            <span class="logo-sm"><img src="/HTML/Admin/dist/assets/images/logo-sm.png" alt="small logo"></span>
        </span>

        <span class="logo-dark">
            <span class="logo-lg"><img src="/HTML/Admin/dist/assets/images/logo-dark.png" alt="dark logo"></span>
            <span class="logo-sm"><img src="/HTML/Admin/dist/assets/images/logo-sm.png" alt="small logo"></span>
        </span>
    </a>

    <!-- Sidebar Hover Menu Toggle Button -->
    <button class="button-sm-hover">
        <i class="ri-circle-line align-middle"></i>
    </button>

    <!-- Sidebar Menu Toggle Button -->
    <button class="sidenav-toggle-button">
        <i class="ri-menu-5-line fs-20"></i>
    </button>

    <!-- Full Sidebar Menu Close Button -->
    <button class="button-close-fullsidebar">
        <i class="ti ti-x align-middle"></i>
    </button>

    <div data-simplebar>

        <!-- User -->
        <div class="sidenav-user">
            <div class="dropdown-center text-center">
                <a class="topbar-link dropdown-toggle text-reset drop-arrow-none px-2" data-bs-toggle="dropdown"
                    type="button" aria-haspopup="false" aria-expanded="false">
                    <img src="/HTML/Admin/dist/assets/images/default_profile.png" width="46" class="rounded-circle" alt="user-image">
                    <span class="d-flex justify-content-center gap-1 sidenav-user-name my-2">
                        <span>
                            <span class="mb-0 fw-semibold lh-base fs-15">${loginEmp.empName}</span>
                            <p class="my-0 fs-13 text-muted">Admin Head</p>
                        </span>

                        <i class="ri-arrow-down-s-line d-block sidenav-user-arrow align-middle"></i>
                    </span>
                </a>
                <div class="dropdown-menu dropdown-menu-end">
                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item">
                        <i class="ri-account-circle-line me-1 fs-16 align-middle"></i>
                        <span class="align-middle">개인정보수정</span>
                    </a>

                    <div class="dropdown-divider"></div>

                    <!-- item-->
                    <a href="javascript:void(0);" class="dropdown-item active fw-semibold text-danger">
                        <i class="ri-logout-box-line me-1 fs-16 align-middle"></i>
                        <span class="align-middle">로그아웃</span>
                    </a>
                </div>
            </div>
        </div>

        <!--- Sidenav Menu -->
        <ul class="side-nav">
            <li class="side-nav-item">
                <a href="index.html" class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-dashboard"></i></span>
                    <span class="menu-text"> 대시보드 </span>
                    <span class="badge bg-danger rounded-pill">9+</span>
                </a>
            </li>

            <li class="side-nav-item">
                <a href="apps-chat.html" class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-message"></i></span>
                    <span class="menu-text"> 채팅 </span>
                </a>
            </li>

            <li class="side-nav-item">
                <a href="apps-calendar.html" class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-calendar"></i></span>
                    <span class="menu-text"> 캘린더 </span>
                </a>
            </li>

            <li class="side-nav-item">
                <a data-bs-toggle="collapse" href="#sidebarContacts" aria-expanded="false"
                    aria-controls="sidebarContacts" class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-user-square-rounded"></i></span>
                    <span class="menu-text"> 조직도 </span>
                    <span class="menu-arrow"></span>
                </a>
                <div class="collapse" id="sidebarContacts">
                    <ul class="sub-menu">
                        <li class="side-nav-item">
                            <a href="apps-user-contacts.html" class="side-nav-link">
                                <span class="menu-text">Contacts</span>
                            </a>
                        </li>
                        <li class="side-nav-item">
                            <a href="apps-user-profile.html" class="side-nav-link">
                                <span class="menu-text">Profile</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </li>

            <li class="side-nav-item">
                <a href="apps-email.html" class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-mailbox"></i></span>
                    <span class="menu-text"> 공지사항 </span>
                </a>
            </li>

            <li class="side-nav-item">
                <a href="projectMain" class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-briefcase"></i></span>
                    <span class="menu-text"> 프로젝트 </span>
                </a>
            </li>

            <li class="side-nav-item">
                <a data-bs-toggle="collapse" href="#sidebarInvoice" aria-expanded="false" aria-controls="sidebarInvoice"
                    class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-invoice"></i></span>
                    <span class="menu-text"> 전자결재</span>
                    <span class="menu-arrow"></span>
                </a>
                <div class="collapse" id="sidebarInvoice">
                    <ul class="sub-menu">
                        <li class="side-nav-item">
                            <a href="apps-invoices.html" class="side-nav-link">
                                <span class="menu-text">Invoices</span>
                            </a>
                        </li>
                        <li class="side-nav-item">
                            <a href="apps-invoice-details.html" class="side-nav-link">
                                <span class="menu-text">View Invoice</span>
                            </a>
                        </li>
                        <li class="side-nav-item">
                            <a href="apps-invoice-create.html" class="side-nav-link">
                                <span class="menu-text">Create Invoice</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
            
            
            <li class="side-nav-item">
                <a data-bs-toggle="collapse" href="#sidebarTasks" aria-expanded="false" aria-controls="sidebarTasks"
                    class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-layout-kanban"></i></span>
                    <span class="menu-text"> Tasks</span>
                    <span class="menu-arrow"></span>
                </a>
                <div class="collapse" id="sidebarTasks">
                    <ul class="sub-menu">
                        <li class="side-nav-item">
                            <a href="apps-kanban.html" class="side-nav-link">
                                <span class="menu-text">Kanban</span>
                            </a>
                        </li>
                        <li class="side-nav-item">
                            <a href="apps-task-details.html" class="side-nav-link">
                                <span class="menu-text">View Details</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
            
            <li class="side-nav-item">
                <a href="apps-file-manager.html" class="side-nav-link">
                    <span class="menu-icon"><i class="ti ti-folders"></i></span>
                    <span class="menu-text"> File Manager </span>
                </a>
            </li>
        </ul>
        <div class="clearfix"></div>
    </div>
</div>
<!-- Sidenav Menu End -->
</body>
</html>