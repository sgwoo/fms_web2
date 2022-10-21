<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.insur.*, acar.mng_exp.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="mg_db" class="acar.mng_exp.GenExpDatabase" scope="page"/>
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
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	int count = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "06", "04");
	
	car_ext = c_db.getIdByNameCode("0032", t_wd.substring(0,2)) ;
	
	
	//System.out.println("car_ext: "+car_ext);
	

	Vector vts = new Vector();
	int vt_size = 0;
	
	//자동차세 리스트
	vts = ai_db.getExpRtnScdReqList(car_ext);
	vt_size = vts.size();
	
	
	
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

		
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); return; }		
		if(fm.gov_id.value == '')		{ alert('수신기관을 선택하십시오.'); return; }		
		if(fm.gov_nm.value == '')		{ alert('수신기관을 선택하십시오.'); return; }

		if(fm.size.value == '0')		{ alert('과태료를 조회 하십시오.'); return; }

		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "car_exp_reg_sc_a.jsp";
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
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="6%">연번</td>
                    <td width='10%' class=title>차량번호</td>
					<td width='15%' class=title >차명</td>
					<td width='10%' class=title>최초등록일</td>
					<td width='10%' class=title>최종납부일</td>
					<td width='20%' class=title>용도변경</td>
					<td width='25%' class=title>명의이전</td>		
                </tr>
<%	
		
	
	
	String vid[] = request.getParameterValues("cho_id");
	String vid_num="";
	String ch_car_no="";
	String ch_car_ext="";
	String ch_c_id="";
	String ch_exp_dt="";
	
	
	for(int i=0; i<vid.length;i++) {
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_car_no = token1.nextToken().trim();	 
				ch_car_ext = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();
				ch_exp_dt = token1.nextToken().trim();
									
		}		
				
		Hashtable ht = mg_db.getGenExpListExcel(ch_car_no, ch_car_ext, ch_c_id, ch_exp_dt);
		
		//신청일 저장.
		mg_db.changeRtn_req_dt(ch_car_no, ch_car_ext, ch_c_id, ch_exp_dt);
				
				%>	  
                <tr> 
				<input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
				
					<td align='center'><a href="javascript:view_car_exp('<%=ht.get("CAR_MNG_ID")%>')"><%=i+1%></a></td>
					<td align='center'><%=ht.get("CAR_NO")%></td>
					<td align='center'><%=ht.get("CAR_NM")%></td>
					<td align='center'><%=ht.get("INIT_REG_DT")%></td>			
					<td align='center'><%=ht.get("EXP_DT")%></td>
					<td>&nbsp;<%=ht.get("CHA_CONT")%></td>
					<td>&nbsp;<%=ht.get("SUI_CONT")%></td>			
				</tr>
<%		count++;
	}%>		
                <input type='hidden' name='size' value='<%=count%>'>  
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
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
