<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.insur.*, acar.estimate_mng.*"%>
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
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "06");
	
	
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	//변수
	String var1 = e_db.getEstiSikVarCase("1", "", "ins1");//담당부서장
	String var2 = e_db.getEstiSikVarCase("1", "", "ins2");	//담당자?
	String var3 = e_db.getEstiSikVarCase("1", "", "ins_app1");//첨부서류1
	String var4 = e_db.getEstiSikVarCase("1", "", "ins_app2");//첨부서류2
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//등록하기
	function ins_doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.doc_id.value 	= sh_fm.doc_id.value;
		fm.doc_dt.value 	= sh_fm.doc_dt.value;
		fm.gov_id.value 	= sh_fm.gov_id.value;
		fm.mng_dept.value 	= sh_fm.mng_dept.value;
		fm.mng_nm.value 	= sh_fm.mng_nm.value;
		fm.mng_pos.value 	= sh_fm.mng_pos.value;
		fm.gov_st.value 	= sh_fm.gov_st.value;
		fm.h_mng_id.value 	= sh_fm.h_mng_id.value;
		fm.b_mng_id.value 	= sh_fm.b_mng_id.value;
		
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); return; }		
		if(fm.gov_id.value == '')		{ alert('수신기관을 선택하십시오.'); return; }		

		if(fm.size.value == '0')		{ alert('해지보험을 조회 하십시오.'); return; }

		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "ins_doc_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='' method='post'>
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
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="30" rowspan="2">연번</td>
            <td width='90' class='title' rowspan="2">증권번호</td>
            <td width='70' class='title' rowspan="2">해지구분</td>			
            <td colspan="2" class='title'>차량번호</td>
            <td width="120" rowspan="2" class='title'>차량명</td>
            <td width="80" rowspan="2" class='title'>해지일자</td>
            <td width='210' class='title' rowspan="2">첨부서류</td>
          </tr>
          <tr>
            <td width='100' class='title'>변경전</td> 
            <td width='100' class='title'>변경후</td>
          </tr>
<%	//선택리스트
	InsDatabase ai_db = InsDatabase.getInstance();
	String vid[] = request.getParameterValues("cho_id");
	String vid_num="";
	String ch_c_id="";
	String ch_ins_st="";
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		ch_c_id = vid_num.substring(0,6);
		ch_ins_st = vid_num.substring(6);
		Hashtable ht = ai_db.getInsClsMngListCase_200704(ch_c_id, ch_ins_st);
%>		  
          <tr align="center"> 
            <td><%=i+1%>
			<input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
			<input type='hidden' name='ins_st' value='<%=ch_ins_st%>'>	
			</td>
            <td><input type="text" name="ins_con_no" size="9" class="whitetext" value="<%=ht.get("INS_CON_NO")%>"></td>			
            <td><input type="text" name="exp_st" size="9" class="whitetext" value="<%=ht.get("CAU")%>"></td>
            <td><input type="text" name="car_no_b" size="12" class="whitetext" value="<%=ht.get("BE_CAR_NO")%>"></td>
            <td><input type="text" name="car_no_a" size="12" class="whitetext" value="<%=ht.get("CAR_NO")%>"></td>
            <td><input type="text" name="car_nm" size="20" class="whitetext" value="<%=ht.get("CAR_NM")%>"></td>
            <td><input type="text" name="exp_dt" size="11" class="whitetext" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_DT")))%>"></td>
            <td><select name="app_st">
              <option value="2"><%=var4%></option>
              <option value="1"><%=var3%></option>			  
            </select></td>
          </tr>
<%		count++;
	}%>		
<input type='hidden' name='size' value='<%=count%>'>  
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
      <td align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <a href='javascript:ins_doc_reg()' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif align=absmiddle border=0></a>
	  <%}%>
	  </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
