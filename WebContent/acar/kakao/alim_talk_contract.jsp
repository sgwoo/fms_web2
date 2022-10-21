<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="acar.kakao.*, acar.cont.*, acar.fee.*, acar.client.*, acar.car_mst.*, acar.car_register.*" %>
<%@ page import="acar.cont.AddContDatabase" %>
<%@ page import="acar.cont.CarMgrBean" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="at_db" scope="page" class="acar.kakao.AlimTemplateDatabase"/>
<jsp:useBean id="cr_bean" scope="page" class="acar.car_register.CarRegBean"/>

<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
    // 파라미터
    String rentMngId = request.getParameter("mng_id")==null? "":request.getParameter("mng_id");
    String rentLCode = request.getParameter("l_cd")==null? "":request.getParameter("l_cd");
    String carCompId = request.getParameter("car_comp_id")==null? "":request.getParameter("car_comp_id");
    String rent_st = request.getParameter("rent_st")==null? "":request.getParameter("rent_st");
    String dept_id = request.getParameter("dept_id") == null ? "" : request.getParameter("dept_id");
    
    AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	
    CarRegDatabase crd = CarRegDatabase.getInstance();
    AlimTalkLogDatabase atl_db = AlimTalkLogDatabase.getInstance();
    
  	//계약기본정보
  	ContBaseBean base = a_db.getCont(rentMngId, rentLCode);
  	
  	//고객정보
  	ClientBean client = al_db.getNewClient(base.getClient_id());
  	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rentMngId, rentLCode);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rentMngId, rentLCode);
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(cr_bean.getCar_num().equals("")){
		pur.getCar_num();
	}
	
  	//대여갯수 카운터
  	int fee_count	= af_db.getFeeCount(rentLCode);
  	if (rent_st.equals("")) {
  		rent_st = String.valueOf(fee_count);
  	}
  	//기존대여스케줄 대여횟수 최대값
  	int max_fee_tm 	= a_db.getMax_fee_tm(rentMngId, rentLCode, rent_st);

    // 카카오 템플릿 코드 리스트
    // 여기에 추가하면 자동으로 테이블에 들어감 (템플릿 관리중인 코드만 들어가야 합니다.)
    // 예) 관리 : Y, 사용 : Y
    /* String[] templateCodes = {
		"acar0231",		//보험및 긴급출동 안내 new
		"acar0233",		//아마존카 사고처리 안내
		"acar0208",		//차량검사 안내
		"acar0194",		//1회차 미납 연체 안내
		"acar0211",		//대여개시 안내
		"acar0193",		//계약해지 및 차량반납통보
		"acar0155",		//연장계약서 메일발송 알림
		"acar0255",		//월렌트 계약확정 안내
		"acar0170",    	//월렌트 계약종료 안내
		"acar0198",		//고소장 진행 시 문자 및 알림톡 내용
		"acar0164",		//블루링크 서비스 가입방법 안내
		"acar0221"		//FMS(fleet management system) 이용방법 안내
    }; */
    
    String[] templateCodes = null;
    //협력업체는 서버가 틀린관계로 해당 페이지 사용 불가
    if(dept_id.equals("1000")){		// 에이전트 fms

	    if (carCompId.equals("0001")) {
	    	
	    	String temp_car_nm = cm_bean.getCar_nm();
	    	temp_car_nm.replace(" ", "");
	    	
	    	if ((temp_car_nm.contains("제네시스") == false) && !client.getClient_st().equals("1") && base.getCar_gu().equals("1")) {
	    		templateCodes = new String[] {
		   			"acar0211",		// 대여개시 안내
		   			"acar0221",		// FMS(fleet management system) 이용방법 안내
		   			"acar0231",		// 보험 및 긴급출동 안내 new
		   			"acar0233",		// 아마존카 사고처리 안내
		   			"acar0164",		// 블루링크 서비스 가입방법 안내
		   			"acar0230",		// 블루멤버스 안내 알림톡
		   			"acar0268",		// 선수금 납부안내문
		   			
		    	};
	    	} else {
	    		if (base.getCar_gu().equals("1")) {//신차
			    	templateCodes = new String[] {
			   			"acar0211",		// 대여개시 안내
			   			"acar0221",		// FMS(fleet management system) 이용방법 안내
		   				"acar0231",		// 보험및 긴급출동 안내 new
		   				"acar0233",		// 아마존카 사고처리 안내
			   			"acar0164",		// 블루링크 서비스 가입방법 안내
			   			"acar0268",		// 선수금 납부안내문
		    		};
	    		}else{
			    	templateCodes = new String[] {//재리스
				   			"acar0211",		// 대여개시 안내
				   			"acar0221",		// FMS(fleet management system) 이용방법 안내
			   				"acar0231",		// 보험및 긴급출동 안내 new
			   				"acar0233",		// 아마존카 사고처리 안내
				   			"acar0164",		// 블루링크 서비스 가입방법 안내
				   			"acar0277",		// 선수금 납부안내문(재리스)
			    		};	    			
	    		}
		    	
	    	}
		} else {
			if (base.getCar_gu().equals("1")) {//신차
		    	templateCodes = new String[] {
		   			"acar0211",		// 대여개시 안내
	   				"acar0221",		// FMS(fleet management system) 이용방법 안내
	   				"acar0231",		// 보험및 긴급출동 안내 new
	   				"acar0233",		// 아마존카 사고처리 안내
		   			"acar0268",		// 선수금 납부안내문
				};
			}else{
		    	templateCodes = new String[] {
			   			"acar0211",		// 대여개시 안내
		   				"acar0221",		// FMS(fleet management system) 이용방법 안내
		   				"acar0231",		// 보험및 긴급출동 안내 new
		   				"acar0233",		// 아마존카 사고처리 안내
			   			"acar0277",		// 선수금 납부안내문(재리스)
					};				
			}
		}
     	
    } else {		// 직원 fms
    	
	    if (carCompId.equals("0001")) {
	    	
	    	String temp_car_nm = cm_bean.getCar_nm();
	    	temp_car_nm.replace(" ", "");
	    	
	    	if ((temp_car_nm.contains("제네시스") == false) && !client.getClient_st().equals("1") && base.getCar_gu().equals("1")) {
	    		
		    	templateCodes = new String[] {
		   			"acar0231",		//보험및 긴급출동 안내 new
		   			"acar0233",		//아마존카 사고처리 안내
		   			"acar0208",		//차량검사 안내
		   			"acar0194",		//1회차 미납 연체 안내
		   			"acar0211",		//대여개시 안내
		   			"acar0193",		//계약해지 및 차량반납통보
		   			"acar0155",		//연장계약서 메일발송 알림
		   			"acar0255",		//월렌트 계약확정 안내
		   			"acar0170",    	//월렌트 계약종료 안내
		   			"acar0198",		//고소장 진행 시 문자 및 알림톡 내용
		   			"acar0221",		//FMS(fleet management system) 이용방법 안내
		   			"acar0164",		//블루링크 서비스 가입방법 안내
		   			"acar0230",		//블루멤버스 안내 알림톡
		   			"acar0268",		// 선수금 납부안내문
		    	};
		    	
	    	} else {
	    		if (base.getCar_gu().equals("1")) {//신차	    		
			    	templateCodes = new String[] {
			   			"acar0231",		//보험및 긴급출동 안내 new
			   			"acar0233",		//아마존카 사고처리 안내
		   				"acar0208",		//차량검사 안내
		   				"acar0194",		//1회차 미납 연체 안내
			   			"acar0211",		//대여개시 안내
			   			"acar0193",		//계약해지 및 차량반납통보
			   			"acar0155",		//연장계약서 메일발송 알림
		   				"acar0255",		//월렌트 계약확정 안내
		   				"acar0170",    	//월렌트 계약종료 안내
			   			"acar0198",		//고소장 진행 시 문자 및 알림톡 내용
			   			"acar0221",		//FMS(fleet management system) 이용방법 안내
			   			"acar0164",		//블루링크 서비스 가입방법 안내
		   				"acar0268",		// 선수금 납부안내문
			    	};
	    		}else{
			    	templateCodes = new String[] {
				   			"acar0231",		//보험및 긴급출동 안내 new
				   			"acar0233",		//아마존카 사고처리 안내
			   				"acar0208",		//차량검사 안내
			   				"acar0194",		//1회차 미납 연체 안내
				   			"acar0211",		//대여개시 안내
				   			"acar0193",		//계약해지 및 차량반납통보
				   			"acar0155",		//연장계약서 메일발송 알림
			   				"acar0255",		//월렌트 계약확정 안내
			   				"acar0170",    	//월렌트 계약종료 안내
				   			"acar0198",		//고소장 진행 시 문자 및 알림톡 내용
				   			"acar0221",		//FMS(fleet management system) 이용방법 안내
				   			"acar0164",		//블루링크 서비스 가입방법 안내
			   				"acar0277",		// 선수금 납부안내문(재리스)
				    	};	    			
	    		}
		    	
	    	}
	    	
	    } else {
	    	if (base.getCar_gu().equals("1")) {//신차	    	
		    	templateCodes = new String[] {
		   			"acar0231",		//보험및 긴급출동 안내 new
	   				"acar0233",		//아마존카 사고처리 안내
	   				"acar0208",		//차량검사 안내
		   			"acar0194",		//1회차 미납 연체 안내
		   			"acar0211",		//대여개시 안내
	   				"acar0193",		//계약해지 및 차량반납통보
	   				"acar0155",		//연장계약서 메일발송 알림
		   			"acar0255",		//월렌트 계약확정 안내
		   			"acar0170",    	//월렌트 계약종료 안내
	   				"acar0198",		//고소장 진행 시 문자 및 알림톡 내용
	   				"acar0221",		//FMS(fleet management system) 이용방법 안내
		   			"acar0268",		//선수금 납부안내문
	    		};
	    	}else{
		    	templateCodes = new String[] {
			   			"acar0231",		//보험및 긴급출동 안내 new
		   				"acar0233",		//아마존카 사고처리 안내
		   				"acar0208",		//차량검사 안내
			   			"acar0194",		//1회차 미납 연체 안내
			   			"acar0211",		//대여개시 안내
		   				"acar0193",		//계약해지 및 차량반납통보
		   				"acar0155",		//연장계약서 메일발송 알림
			   			"acar0255",		//월렌트 계약확정 안내
			   			"acar0170",    	//월렌트 계약종료 안내
		   				"acar0198",		//고소장 진행 시 문자 및 알림톡 내용
		   				"acar0221",		//FMS(fleet management system) 이용방법 안내
			   			"acar0277",		// 선수금 납부안내문(재리스)
		    		};	    		
	    	}
	    }
    }
             
    // DB에서 템플릿 리스트 가져옴 - log는 show_list가 no여도 display 
	// AlimTemplateDatabase at_db = AlimTemplateDatabase.getInstance();
  	// List<AlimTemplateBean> allTemplateList = at_db.selectTemplateList("0", false);
  	// log 용 - 20171212
	List<AlimTemplateBean> allTemplateList = at_db.selectTemplateLogList("0", "0", false); 
     
    // 보여줄 템플릿 리스트만 골라냄
    ArrayList<AlimTemplateBean> templateList = new ArrayList<AlimTemplateBean>();

    for (int i = 0; i < allTemplateList.size(); i++) {
        AlimTemplateBean template = allTemplateList.get(i);

        for (int j = 0; j < templateCodes.length; j++) {
            if (template.getCode().equals(templateCodes[j])) {
                templateList.add(template);
            }
        }
    }

    // 알림톡 로그 가져옴 (계약번호로 검색)  - log는 show_list가 no여도 display 
	List<AlimTalkLogBean> logList = atl_db.selectByContract(rentLCode);

    // 템플릿별 최근 로그 한개씩 저장
    HashMap<String, AlimTalkLogBean> recentLog = new HashMap<String, AlimTalkLogBean>();
    for (int i = 0; i < logList.size(); i++) {
        AlimTalkLogBean log = logList.get(i);
        for (int j = 0; j < templateCodes.length; j++) {

            // 맵에 한개씩만 저장한다
            if (log.getTemplate_code() != null && log.getTemplate_code().equals(templateCodes[j])) {
               if (recentLog.containsKey(templateCodes[j]) == false) {
                   recentLog.put(templateCodes[j], log);
               }
            }
        }
    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

<style type="text/css">
    .table-style-1 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        color: #515150;
        font-weight: bold;
    }
    .table-back-1 {
        background-color: #B0BAEC
    }
    .table-body-1 {
        text-align: center;
        height: 26px;
    }
    .table-body-2 {
        text-align: left;
        padding-left: 10px;
        font-size: 10pt;
    }
    .font-1 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        font-weight: bold;
    }
    .font-2 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
    }
</style>

<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">

	var rentMngId = '<%= rentMngId %>';
	var rentLCode = '<%= rentLCode %>';
	var carCompId = '<%= carCompId %>';
	var rentSt = '<%= rent_st %>';
	var max_fee_tm = '<%= max_fee_tm %>';

	$(document).ready(function(){
	
	});

	// 알림톡 발송 클릭 - 배치로 처리되는 경우 show_list가 'N'인경우도 있음.
	function onClickSend(category_1, templateCode) {
		
		if (templateCode == "acar0221") {
			if (max_fee_tm == "" || max_fee_tm == "0") {
				alert("생성된 스케줄이 없습니다. 확인하십시오.");
				return;
			}
		}
		
		// alert("SEND (mng_id: " + rentMsgId + " l_cd: " + rentLCode + " template_code: " + templateCode + ")");
		var url = '/acar/kakao/alim_talk.jsp?s_type=log&cate=1&cate1=' + category_1 + '&t_cd=' + templateCode + '&mng_id=' + rentMngId + '&l_cd=' + rentLCode + '&rent_st=' + rentSt;
		window.open(url, 'ALIM_TALK', "left=50, top=50, width=850, height=850, scrollbars=yes");
	}
	
	// 이력 보기 클릭
	function onClickHistory(templateCode) {
		// alert("HISTORY (template_code: " + templateCode + ")");
		var url = '/acar/kakao/alim_talk_log.jsp?s_type=log&t_cd=' + templateCode + '&mng_id=' + rentMngId + '&l_cd=' + rentLCode;
		window.open(url, 'ALIM_TALK_LOG', "left=50, top=50, width=1250, height=850, scrollbars=yes");
	}

</script>
</head>

<body leftmargin="15">

<%-- 헤더 --%>
<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>알림톡 > <span class=style5>알림톡발송관리</span></span></td>
                        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr><td class=h></td></tr>
    </table>
</div>

<%-- 알림톡 발송 --%>
<div>
    <br>
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">알림톡 발송</div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="700" style="margin-top: 8px">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td rowspan="2" class="title" width=5%>연번</td>
            <td rowspan="2" class="title" width=35%>안내문</td>
            <td rowspan="2" class="title" width=10%>선택</td>
            <td colspan="3" class="title" width=50%>최근발송이력</td>
        </tr>
        <tr>
            <td class="title" width=15%>일시</td>
            <td class="title" width=25%>발송자</td>
            <td class="title" width=10%>이력보기</td>
        </tr>
        <% for (int i = 0; i < templateList.size(); i++) {
            AlimTemplateBean template = templateList.get(i);
        %>
            <tr class="table-body-1">
                <td><%= i + 1 %></td>
                <td class="table-body-2"><%= template.getName() %></td>
                <td><button onclick="onClickSend('<%= template.getCategory_1() %>','<%= template.getCode() %>')">전송</button></td>

                <%  if (recentLog.containsKey(template.getCode())) {
                        AlimTalkLogBean log = recentLog.get(template.getCode());
                %>
                        <td><%=log.getDate_client_req_str()%></td>
                        <% if (log.getUserNm() == null || log.getUserNm().equals("")) { %>
                            <td><%=log.getCallback()%></td>
                        <% } else { %>
                            <td><%=log.getUserNm()%></td>
                        <% } %>
                        <td><button onclick="onClickHistory('<%= template.getCode() %>')">보기</button></td>
                <%  } else { %>
                        <td>-</td><td>-</td><td>-</td>
                <%  } %>
            </tr>
        <% } %>

    </table>
</div>

</body>
</html>
