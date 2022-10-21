<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.condition.*"%>
<%@ page import="acar.receive.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>

<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
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
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "06");
	
	String car_no = "";

	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//등록하기
	function doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
	   
		fm.n_ven_code.value 	= sh_fm.n_ven_code.value;
		fm.n_ven_name.value 	= sh_fm.n_ven_name.value;		
		fm.re_dept.value 	= sh_fm.re_dept.value;				
		fm.re_nm.value 	= sh_fm.re_nm.value;
		fm.re_fax.value 	= sh_fm.re_fax.value;				
		fm.re_tel.value 	= sh_fm.re_tel.value;
		fm.re_phone.value 	= sh_fm.re_phone.value;				
		fm.re_mail.value 	= sh_fm.re_mail.value;
		fm.bank_cd.value 	= sh_fm.bank_cd.value;				
		fm.bank_nm.value 	= sh_fm.bank_nm.value;
		fm.bank_no.value 	= sh_fm.bank_no.value;			
		fm.re_bank_cd.value 	= sh_fm.re_bank_cd.value;
		fm.re_bank_nm.value 	= sh_fm.re_bank_nm.value;				
		fm.re_bank_no.value 	= sh_fm.re_bank_no.value;
		
		fm.req_dt.value 	= sh_fm.req_dt.value;				
	
		if(fm.req_dt.value == '')		{ alert('위임일자를 입력하세요.'); return; }		
		if(fm.n_ven_name.value == '')		{ alert('위임업체를 선택하십시오.'); return; }
	
		if(fm.size.value == '0')		{ alert(' 차량을 조회 하십시오.'); return; }
				
		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "receive_reg_step1_off_a.jsp";
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

<input type='hidden' name='n_ven_code' value=''>
<input type='hidden' name='n_ven_name' value=''>
<input type='hidden' name='re_rate' value='25'>

<input type='hidden' name='re_dept' value=''>
<input type='hidden' name='re_nm' value=''>
<input type='hidden' name='re_fax' value=''>
<input type='hidden' name='re_tel' value=''>
<input type='hidden' name='re_phone' value=''>
<input type='hidden' name='re_mail' value=''>

<input type='hidden' name='bank_cd' value=''>
<input type='hidden' name='bank_nm' value=''>
<input type='hidden' name='bank_no' value=''>
<input type='hidden' name='re_bank_cd' value=''>
<input type='hidden' name='re_bank_nm' value=''>
<input type='hidden' name='re_bank_no' value=''>
<input type='hidden' name='req_dt' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="6%">연번</td>
                   	 <td width='7%' class='title'>계약번호</td>
                       <td width='7%' class='title'>차량번호</td>
                       <td width='12%' class='title'>차명</td>
                       <td width=20% class='title'>상호</td>  
                       <td width=10% class='title'>해지일</td>  
                       <td width=10% class='title'>회차</td>  
                       <td width=10% class='title' >금액</td>								  
                       <td width=7% class='title' >보증보험</td>        
                       <td width=7% class='title' >영업담당</td>   
                </tr>
<% 	
	//선택리스트
	
	
	String vid[] = request.getParameterValues("pr");
	String vid_num="";
	String ch_rent_mng_id="";
	String ch_rent_l_cd="";
	String ch_car_mng_id="";
    String ch_car_amt ="";
    String ch_tm ="";
    String ch_gi_amt ="";
   
	int car_amt = 0;
	
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
			    ch_rent_mng_id = token1.nextToken().trim();	 			
				ch_rent_l_cd = token1.nextToken().trim();	 
				ch_car_mng_id = token1.nextToken().trim();	 
				ch_car_amt = token1.nextToken().trim();	 	
				ch_tm = token1.nextToken().trim();	 	
				ch_gi_amt = token1.nextToken().trim();	 	
								
		}		
		
	 //추심정보
	   ClsBandBean cls_band = re_db.getClsBandInfo(ch_rent_mng_id, ch_rent_l_cd);
		
	   if(!cls_band.getRent_l_cd().equals("")) continue; //기등록분은 skip
	   
	   Hashtable fee_base = re_db.getClsContInfo(ch_rent_mng_id, ch_rent_l_cd);

			
%>		  
 		        <tr align="center"> 
                    <td><%=i+1%></td>
                		<input type='hidden' name='car_mng_id' value='<%=ch_car_mng_id%>'>  
                		<input type='hidden' name='rent_mng_id' value='<%=ch_rent_mng_id%>'>            
                		<input type='hidden' name='rent_l_cd' value='<%=ch_rent_l_cd%>'>     
                		<input type='hidden' name='band_amt' value='<%=ch_car_amt%>'>       
                		<input type='hidden' name='basic_dt' value='<%=fee_base.get("CLS_DT")%>'>           
                    <td><%=fee_base.get("RENT_L_CD")%></td>
                    <td><%=fee_base.get("CAR_NO")%></td>
                    <td><%=fee_base.get("CAR_NM")%></td>
                    <td><%=fee_base.get("FIRM_NM")%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(fee_base.get("CLS_DT")))%></td>
                    <td><%=ch_tm%></td><!--  회차 -->
                    <td align='right'><%=AddUtil.parseDecimal(ch_car_amt)%></td>
                    <td  align='right'><%=AddUtil.parseDecimal(ch_gi_amt)%></td><!--보증보험 -->
                    <td><%=c_db.getNameById((String)fee_base.get("BUS_ID2"),"USER")%></td><!--  회차 -->
                                             
               
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
