<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
		
	int count = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "06", "04");
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수정: 스캔 보기
	function view_map(map_path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			

	//예약시스템 계약서
	function view_scan_res(c_id, s_cd){
		window.open("/acar/rent_mng/res_rent_u_print.jsp?c_id="+c_id+"&s_cd="+s_cd+"&mode=fine_doc", "VIEW_SCAN_RES", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
		
	//팝업윈도우 열기-스캔ㅂ기
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/fine/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//등록하기
	function fine_doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.doc_id.value 	= sh_fm.doc_id.value;
		fm.doc_dt.value 	= sh_fm.doc_dt.value;
		fm.gov_id.value 	= sh_fm.gov_id.value;
		fm.gov_nm.value 	= sh_fm.gov_nm.value;		
		fm.doc_id.value 	= sh_fm.doc_id.value;
		fm.mng_dept.value 	= sh_fm.mng_dept.value;
		fm.gov_st.value 	= sh_fm.gov_st.value;
		fm.mng_nm.value 	= sh_fm.mng_nm.value;
		fm.mng_pos.value 	= sh_fm.mng_pos.value;
		fm.h_mng_id.value 	= sh_fm.h_mng_id.value;
		fm.b_mng_id.value 	= sh_fm.b_mng_id.value;
		fm.app_doc1.value 	= sh_fm.app_doc1.value;
		fm.app_doc2.value 	= sh_fm.app_doc2.value;
		fm.app_doc3.value 	= sh_fm.app_doc3.value;
		fm.app_doc4.value 	= sh_fm.app_doc4.value;
		
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); return; }		
		if(fm.gov_id.value == '')		{ alert('수신기관을 선택하십시오.'); return; }		
		if(fm.gov_nm.value == '')		{ alert('수신기관을 선택하십시오.'); return; }

		if(fm.size.value == '0')		{ alert('과태료를 조회 하십시오.'); return; }
		
		
		//if(fm.size.value == '1'){
		//	var v_dt = toInt(replaceString('-','',fm.vio_dt.value).substring(0,8));
		//	var s_dt = toInt(replaceString('-','',fm.rent_start_dt.value).substring(0,8));
		//	var e_dt = toInt(replaceString('-','',fm.rent_end_dt.value).substring(0,8));
		//	if(v_dt < s_dt){ alert('1번 위반일보다 임대시작일이 큽니다.'); return;}
		//	if(v_dt > e_dt){ alert('1번 위반일보다 임대종료일 작습니다.'); return;}
		//}else{
			for(i=0; i<toInt(fm.size.value); i++){ 
				var v_dt = toInt(replaceString('-','',fm.vio_dt[i].value).substring(0,8));
				var s_dt = toInt(replaceString('-','',fm.rent_start_dt[i].value).substring(0,8));
				var e_dt = toInt(replaceString('-','',fm.rent_end_dt[i].value).substring(0,8));
				if(v_dt < s_dt){ alert((i+1)+'번 위반일보다 임대시작일이 큽니다.'); return;}
				if(v_dt > e_dt){ alert((i+1)+'번 위반일보다 임대종료일 작습니다.'); return;}
			}
		//}
		

		if(!confirm('등록하시겠습니까?')){	return;	}

		fm.action = "fine_doc_reg_sc_a.jsp";

		fm.target = "i_no";
		fm.submit()
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='fine_doc_reg_sc_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='doc_dt' value=''>
<input type='hidden' name='gov_id' value=''>
<input type='hidden' name='gov_nm' value=''>
<input type='hidden' name='mng_dept' value=''>
<input type='hidden' name='gov_st' value=''>
<input type='hidden' name='mng_nm' value=''>
<input type='hidden' name='mng_pos' value=''>
<input type='hidden' name='h_mng_id' value=''>
<input type='hidden' name='b_mng_id' value=''>
<input type='hidden' name='app_doc1' value=''>
<input type='hidden' name='app_doc2' value=''>
<input type='hidden' name='app_doc3' value=''>
<input type='hidden' name='app_doc4' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
    <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	      <a href='javascript:fine_doc_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>
	    <%}%>
	  </td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr> 
    <td class="line"> 
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td class='title' width="4%" rowspan="2">연번</td>
          <td width='19%' class='title' rowspan="2">고지서번호</td>
          <td width='10%' class='title' rowspan="2">차량번호</td>
          <td colspan="5" class='title'>임차인</td>
        </tr>
        <tr>
          <td width='16%' class='title'>상호/성명</td>
          <td width='11%' class='title'>생년월일</td>
          <td width='11%' class='title'>운전면허번호</td>
          <td width='11%' class='title'>사업자등록번호</td>
          <td width='15%' class='title'>임대기간</td>
        </tr>
        <%for(int i=0; i<100;i++){%>
        <tr align="center" id=tr_fine<%=i%> style='display:none'>
          <td><%=i+1%>        	
            <input type='hidden' name='car_mng_id' value=''>
            <input type='hidden' name='seq_no' value=''>
            <input type='hidden' name='rent_mng_id' value=''>
            <input type='hidden' name='rent_l_cd' value=''>
            <input type='hidden' name='con_agnt_email' value=''>
            <input type='hidden' name='rent_s_cd' value=''>
            <input type='hidden' name='rent_st' value=''>
            <input type='hidden' name='prepare' value=''>
            <input type='hidden' name='client_id' value=''>
            <input type='hidden' name='vio_dt' value=''>
          </td>
          <td><input type="text" name="paid_no" size="25" class="whitetext" value="" readonly></td>
          <td><input type="text" name="car_no" size="12" class="whitetext" value="" readonly></td>
          <td><input type="text" name="firm_nm" size="30" class="whitetext" value="" readonly></td>
          <td><input type="text" name="ssn" size="15" class="whitetext" value="" readonly></td>
          <td><input type="text" name="lic_no" size="15" class="whitetext" value="" readonly></td>
          <td><input type="text" name="enp_no" size="15" class="whitetext" value="" readonly></td>
          <td><input type="text" name="rent_start_dt" size="12" class="whitetext" value=""> ~ <input type="text" name="rent_end_dt" size="12" class="whitetext" value=""></td>
        </tr>
        <%}%>
      </table>
    </td>
  </tr>
  <tr> 
    <td class=h></td>
  </tr>
  <input type='hidden' name='size' value='<%=count%>'>
  <tr>
    <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	      <a href='javascript:fine_doc_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>
	    <%}%>
	  </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
