<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.cont.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id		= ck_acar_id;
	
	String mgr_ssn		= "연장견적";
	
	if(rent_st.equals("1")){
		mgr_ssn		= "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstimateBean [] e_r = e_db.getEstimateContList(rent_mng_id, rent_l_cd, mgr_ssn);
	int size = e_r.length;
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
		
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	
	int count = 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function EstiDoc(rent_st, est_id){
		var SUBWIN="/acar/secondhand_hp/estimate_fms_ym.jsp?est_id="+est_id+"&acar_id=<%=user_id%>&from_page=/fms2/lc_rent/lc_s_frame.jsp";
		if(rent_st=='1'){
			SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		}
		window.open(SUBWIN, "EstiDoc", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 
	}
	function estimates_view(rent_st, reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=<%=base.getCar_gu()%>&rent_st="+rent_st+"&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//선택출력하기
	function select_print(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("견적을 선택하세요.");
			return;
		}	
		
		alert("인쇄미리보기로 페이지 확인후 출력하시기를 권장합니다.");
				
		fm.target = "_blank";
		fm.action = "/acar/secondhand_hp/esti_doc_select_print.jsp";
		fm.submit();	
	}
		
	//선택메일발송
	function select_email(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("견적을 선택하세요.");
			return;
		}	
		
		fm.target = "_blank";
		fm.action = "/acar/apply/select_mail_input.jsp";
		fm.submit();	

	}	
//-->
</script>
</head>
<body>
<form action="esti_mng_u.jsp" name="form1" method="POST">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<%if (rent_st.equals("2")) {%>
<input type="hidden" name="content_st" value="sh_fms_ym">
<%} else {%>
<input type="hidden" name="content_st" value="">
<%}%>
<table border=0 cellspacing=0 cellpadding=0 width=1170>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>견적이력</span></span> : 견적이력</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<%if (!rent_st.equals("1")) {%>
    <tr> 
      <td >	  
	   	<a href="javascript:select_print();" title='선택 출력하기'><img src=/acar/images/center/button_print_se.gif align=absmiddle border=0></a>&nbsp;
	   	<a href="javascript:select_email();" title='선택 메일발송하기'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>&nbsp;
	  </td>
    </tr>
    <%} %>  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td width=100% class='line' > 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <%if (!rent_st.equals("1")) {%><td width=30 class=title>선택</td><%} %>  
                    <td width=30 class=title>연번</td>
                    <td width=50 class=title>구분</td>			
                    <td width=100 class=title>견적번호</td>
                    <td width=100 class=title>대여상품</td>
                    <td width=60 class=title>대여<br>기간</td>
                    <td width=70 class=title>주행거리</td>
                    <td width=50 class=title>신용<br>등급</td>
                    <td width=80 class=title>견적일자</td>                    
                    <td width=90 class=title>차량가격</td>
                    <td width=90 class=title>적용잔가</td>					
                    <td width=80 class=title>월대여료</td>			
                    <td width=90 class=title>보증금</td>
                    <td width=70 class=title>선납금</td>									
                    <td width=70 class=title>개시대여료</td>												
					<td width=60 class=title>등록일</td>
					<td width=50 class=title>등록자</td>					
                </tr>
            <%for(int i=0; i<size; i++){
								bean = e_r[i];
								
								String td_color = "";
								if(bean.getEst_id().equals(fee_etc.getBc_est_id())) td_color = " class='star' ";
					
								count++;
						%>
                <tr> 
                	  <%if (!rent_st.equals("1")) {%><td <%=td_color%> width=40 align=center><input type="checkbox" name="ch_l_cd" value="<%=bean.getEst_id()%>"></td><%} %> 
                    <td <%=td_color%> align=center><%=count%></td>
                    <td <%=td_color%> align=center><%if(bean.getRent_st().equals("t")){%>출고전대차<%}else if(bean.getRent_st().equals("1")){%>신규<%}else{%>연장(<%=bean.getRent_st()%>)<%}%></td>			
                    <td <%=td_color%> align=center><a href="javascript:EstiDoc('<%=bean.getRent_st()%>', '<%=bean.getEst_id()%>')"><%= bean.getEst_id() %></a></td>
                    <td <%=td_color%> align=center><%=c_db.getNameByIdCode("0009", "", bean.getA_a())%></td>
                    <td <%=td_color%> align=center><%=bean.getA_b()%>개월</td>
                    <td <%=td_color%> align="right"><%=Util.parseDecimal(bean.getAgree_dist())%></td>
                    <td <%=td_color%> align=center>
                  			<%if(bean.getSpr_yn().equals("3")){%>신설<%}%>
                  			<%if(bean.getSpr_yn().equals("0")){%>일반<%}%>
                  			<%if(bean.getSpr_yn().equals("1")){%>우량<%}%>
                  			<%if(bean.getSpr_yn().equals("2")){%>초우량<%}%>
                    </td>
                    <td <%=td_color%> align=center><%= AddUtil.ChangeDate2(bean.getRent_dt()) %></td>                    
                    <td <%=td_color%> align="right"><%=Util.parseDecimal(bean.getO_1())%></td>
                    <td <%=td_color%> align="right"><%=Util.parseDecimal(bean.getRo_13_amt())%></td>					
                    <td <%=td_color%> align="right">
                    <%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("임원",user_id)){%>
                    <a href="javascript:estimates_view('<%=bean.getRent_st()%>', '<%=bean.getReg_code()%>')" onMouseOver="window.status=''; return true" title="견적결과 보기"><%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%></a>
                    <%	}else{ %>
                    <%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%>
                    <%	} %>
                    <%if(bean.getCtr_s_amt()>0){ %>
                    <br>(조정대여료<%=Util.parseDecimal(bean.getCtr_s_amt()+bean.getCtr_v_amt())%>)
                    <%} %>
                    </td>
                    <td <%=td_color%> align="right"><%=Util.parseDecimal(bean.getGtr_amt())%></td>
                    <td <%=td_color%> align="right"><%=Util.parseDecimal(bean.getPp_s_amt()+bean.getPp_v_amt())%></td>
                    <td <%=td_color%> align="right"><%=Util.parseDecimal(bean.getIfee_s_amt()+bean.getIfee_v_amt())%></td>												
                    <td <%=td_color%> align=center><%=bean.getReg_dt()%></td>
                    <td <%=td_color%> align=center><%=bean.getTalk_tel()%></td>										
                </tr>
                <%}%>
                <% if(size == 0) { %>
                <tr> 
                    <td align=center height=25 colspan="17">등록된 데이타가 없습니다.</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
    <%if (!rent_st.equals("1")) {%>
    <tr> 
        <td>※ 연장견적서에는 추가운전자 요금 및 선수금 효과 대여료가 가감되어 리스트의 대여료금액과 다를 수 있습니다.</td>
    </tr>
    <%} %>
</table>
</form>
</body>
</html>
