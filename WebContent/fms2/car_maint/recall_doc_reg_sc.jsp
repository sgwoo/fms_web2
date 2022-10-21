<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.condition.*"%>
<jsp:useBean id="c_bean" class="acar.condition.ConditionBean" scope="page"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
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
	function recall_doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.doc_id.value 	= sh_fm.doc_id.value;
		fm.doc_dt.value 	= sh_fm.doc_dt.value;
		fm.print_dt.value 	= sh_fm.print_dt.value;
		fm.f_reason.value 	= sh_fm.f_reason.value;
		fm.f_result.value 	= sh_fm.f_result.value;
		fm.reg_id.value 	= sh_fm.reg_id.value;
		fm.print_id.value 	= sh_fm.print_id.value;
		fm.h_mng_id.value 	= sh_fm.h_mng_id.value;
		fm.b_mng_id.value 	= sh_fm.b_mng_id.value;
		
		fm.car_comp_id.value 	= sh_fm.car_comp_id.value;
		fm.code.value 	= sh_fm.code.value;			
		fm.mng_nm.value 	= sh_fm.mng_nm.value;
		fm.gov_st.value 	= sh_fm.gov_st.value;	
		fm.s_dt.value 	= sh_fm.s_dt.value;
		fm.e_dt.value 	= sh_fm.e_dt.value;	
		fm.ip_dt.value 	= sh_fm.ip_dt.value;
		fm.end_dt.value 	= sh_fm.end_dt.value;
		fm.mng_dept.value 	= sh_fm.mng_dept.value;
		fm.title.value 	= sh_fm.title.value;
		fm.remarks.value 	= sh_fm.remarks.value;
				
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); return; }
		if(fm.f_reason.value == '')	{ alert('접수형태를 입력하십시오.'); return; }
		if(fm.f_result.value == '')		{ alert('고지형태를 입력하십시오.'); return; }
		
		if(fm.doc_dt.value == '')		{ alert('접수일자를 입력하십시오.'); return; }		
		if(fm.print_dt.value == '')		{ alert('고지일자를 입력하십시오.'); return; }		
		
		if(fm.h_mng_id.value == '')		{ alert(' 리콜접수 관리자를 선택하십시오.'); return; }
		if(fm.b_mng_id.value == '')		{ alert('리콜대응고지 관리자를 선택하십시오.'); return; }
		
		
		if(fm.car_comp_id.value == '')		{ alert('제조사를 선택하십시오.'); return; }		
		if(fm.mng_pos.value == '')		{ alert('차종을 선택하십시오.'); return; }		
		
		if(fm.size.value == '0')		{ alert('차량을 선택 하십시오.'); return; }

		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = " recall_doc_reg_sc_a.jsp";
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
<input type='hidden' name='print_dt' value=''>
<input type='hidden' name='f_reason' value=''>
<input type='hidden' name='f_result' value=''>
<input type='hidden' name='reg_id' value=''>
<input type='hidden' name='print_id' value=''>
<input type='hidden' name='h_mng_id' value=''>
<input type='hidden' name='b_mng_id' value=''>
<input type='hidden' name='car_comp_id' value=''>
<input type='hidden' name='code' value=''>
<input type='hidden' name='mng_nm' value=''>
<input type='hidden' name='gov_st' value=''>
<input type='hidden' name='s_dt' value=''>
<input type='hidden' name='e_dt' value=''>
<input type='hidden' name='ip_dt' value=''>
<input type='hidden' name='end_dt' value=''>
<input type='hidden' name='mng_dept' value=''>
<input type='hidden' name='title' value=''>
<input type='hidden' name='remarks' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="6%">연번</td>
                    <td width='10%' class='title'>차량번호</td>
                    <td width='12%' class='title'>차종</td>
                    <td width='16%' class='title'>차대번호</td>
                    <td width='26%' class='title'>계약자</td>
                    <td width='10%' class='title'>계약구분</td>
                    <td width='10%' class='title'>관리담당</td>
                    <td width='10%' class='title'>대응구분</td>
                      
                </tr>
<% 	
	//선택리스트
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String vid[] = request.getParameterValues("cho_id");
	String vid_num="";
	String ch_m_id="";
	String ch_l_cd="";
	String ch_c_id="";
	String ch_bank_id="";   //자동차메이커
	
	
	int loan_amt1_tot = 0; //대출금액 합계
	
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_bank_id = token1.nextToken().trim();	 
			
								
		}		
				
		Hashtable loan = cdb.getRecallListExcel(ch_m_id, ch_l_cd, ch_c_id);
%>		  
 		        <tr align="center"> 
                    <td><%=i+1%></td>
                    <input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
        			<input type='hidden' name='rent_mng_id' value='<%=ch_m_id%>'>
        			<input type='hidden' name='rent_l_cd' value='<%=ch_l_cd%>'>			
        			<input type='hidden' name='rent_s_cd' value=''>
        			<input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>		
        			<input type='hidden' name='firm_nm' value='<%=loan.get("FIRM_NM")%>'>
        			<input type='hidden' name='car_no' value='<%=loan.get("CAR_NO")%>'>
        			<input type='hidden' name='car_nm' value='<%=loan.get("CAR_NM")%>'>
        			<input type='hidden' name='rent_way_nm' value='<%=loan.get("RENT_WAY_NM")%>'>
        			<input type='hidden' name='mng_id' value='<%=loan.get("MNG_ID")%>'>
        			<input type='hidden' name='car_num' value='<%=loan.get("CAR_NUM")%>'>       			
        			        		
        		 <td><%=loan.get("CAR_NO")%></td>		
        		  <td><%=Util.subData(String.valueOf(loan.get("CAR_NM")), 8)%></td>
        		  <td><%=loan.get("CAR_NUM")%></td>
                    <td><span title='<%=loan.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(loan.get("FIRM_NM")), 14)%></td>
               	 <td><%=loan.get("RENT_WAY_NM")%></td>
                    <td><%=loan.get("MNG_NM")%></td>
                     <td>&nbsp;</td>
           
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
	    <a href='javascript:recall_doc_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
       </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
