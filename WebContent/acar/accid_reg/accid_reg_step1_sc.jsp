<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.accid.*, acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();

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
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "06");
	
	String car_no = "";
	String r_m_id = "";
	String r_l_cd = "";	
	

	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/acar/car_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//등록하기
	function doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.reg_dt.value 	= sh_fm.reg_dt.value;
		fm.reg_id.value 	= sh_fm.reg_id.value;
		fm.s_gubun1.value 	= sh_fm.s_gubun1.value;
		fm.dam_type1.value 	= sh_fm.dam_type1.value;				
		fm.sub_etc.value 	= sh_fm.sub_etc.value;
		fm.accid_type.value 	= sh_fm.accid_type.value;
		fm.accid_dt.value 	= sh_fm.accid_dt.value;
		fm.accid_dt_h.value 	= sh_fm.accid_dt_h.value;	
		fm.accid_dt_m.value 	= sh_fm.accid_dt_m.value;
		fm.accid_type_sub.value 	= sh_fm.accid_type_sub.value;
		fm.accid_addr.value 	= sh_fm.accid_addr.value;
		fm.accid_cont.value 	= sh_fm.accid_cont.value;
		fm.accid_cont2.value 	= sh_fm.accid_cont2.value;
		fm.our_fault_per.value 	= sh_fm.our_fault_per.value;
		fm.ot_fault_per.value 	= sh_fm.ot_fault_per.value;
		
		fm.imp_fault_st.value 	= sh_fm.imp_fault_st.value;
		fm.imp_fault_sub.value 	= sh_fm.imp_fault_sub.value;	
			
		if(fm.reg_dt.value == '')		{ alert("접수일자를 입력하십시오."); return; }		
		if(fm.accid_dt.value == '')		{ alert("사고일자를 입력하십시오."); return; }		
		if(fm.size.value == '0')		{ alert('계약을 조회 하십시오.'); return; }

		if(fm.accid_dt_h.value == ''){ fm.accid_dt_h.value='00'; }		
		if(fm.accid_dt_m.value == ''){ fm.accid_dt_m.value='00'; }		
		
		fm.h_accid_dt.value = fm.accid_dt.value+fm.accid_dt_h.value+fm.accid_dt_m.value;	
			
		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "accid_reg_step1_sc_a.jsp";
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
<input type='hidden' name='reg_dt' value=''>
<input type='hidden' name='reg_id' value=''>
<input type='hidden' name='s_gubun1' value=''>
<input type='hidden' name='dam_type1' value=''>
<input type='hidden' name='sub_etc' value=''>
<input type='hidden' name='accid_type' value=''>
<input type='hidden' name='accid_dt' value=''>
<input type='hidden' name='accid_dt_h' value=''>
<input type='hidden' name='accid_dt_m' value=''>
<input type='hidden' name='accid_type_sub' value=''>
<input type='hidden' name='accid_addr' value=''>
<input type='hidden' name='accid_cont' value=''>
<input type='hidden' name='accid_cont2' value=''>
<input type='hidden' name='our_fault_per' value=''>
<input type='hidden' name='ot_fault_per' value=''>
<input type='hidden' name='imp_fault_st' value=''>
<input type='hidden' name='imp_fault_sub' value=''>
<input type='hidden' name="h_accid_dt" value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="6%">연번</td>
                    <td width='12%' class='title'>계약번호</td>
                    <td width='13%' class='title'>차량번호</td>
                    <td width='8%' class='title'>차명</td>
                    <td width='12%' class='title'>연료</td>
                    <td width='12%' class='title'>최초등록일</td>
                    <td width='14%' class='title'>계약일</td>     
                    <td width='14%' class='title'>관리번호</td>      
                                     
                </tr>
<% 	
	//선택리스트
		
	String vid[] = request.getParameterValues("pr");
	String vid_num="";
	String ch_c_id="";
	String ch_m_id="";
	String ch_l_cd="";
			
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {				
				ch_c_id = token1.nextToken().trim();	 
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 			
		}		
				
		Hashtable ht = as_db.getContCommDetail(ch_m_id, ch_l_cd, ch_c_id);
		
%>		  
 		        <tr align="center"> 
                    <td align='center'><%=i+1%></td>
			           			<input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
			        			<input type='hidden' name='rent_mng_id' value='<%=ch_m_id%>'>
			        			<input type='hidden' name='rent_l_cd' value='<%=ch_l_cd%>'>	                 
	                <td align='center'><%=ht.get("RENT_L_CD")%></td>   
	                <td align='center'><%=ht.get("CAR_NO")%></td>                               
	                <td align='center'><%=ht.get("CAR_NM")%></td>
	                <td align='center'><%=c_db.getNameByIdCode("0039", "", String.valueOf(ht.get("FUEL_KD")))%></td>
            		<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>		
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align='center'><%=ht.get("CAR_DOC_NO")%></td>
                
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
	    <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}%>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
