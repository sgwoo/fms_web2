<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	Vector vt = af_db.getFeeScdCngMngList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post' action='pur_pay_sc_in.jsp'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_pay_frame.jsp'>
  <input type='hidden' name='doc_no' value=''>
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width='1300'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='300' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
					<td width=30 class='title'>연번</td>
					<td width="90" class='title'>계약번호</td>
		            <td width=100 class='title'>고객</td>
		            <td width=80 class='title'>차량번호</td>					
   		        </tr>
			</table>
		</td>
		<td class='line' width='1000'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
       		        <td width=100 class='title'>항목</td>
       		        <td width=100 class='title'>회차</td>
			        <td width=160 class='title'>변경전</td>
			        <td width=160 class='title'>변경후</td>
					<td width=300 class='title'>사유</td>
			        <td width=50 class='title'>등록자</td>
			        <td width=130 class='title'>등록일시</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='300' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
				  <td  width=30 align='center'><%=i+1%></td>
				  <td width="90" align='center'><a href="javascript:parent.view_scd_fee('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("RENT_ST")%>', '<%//=ht.get("REG_YN")%>','<%//=ht.get("GUBUN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
				  <td width="100">&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
				  <td  width=80 align='center'><%=ht.get("CAR_NO")%></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1000'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
				    <td  width=100 align='center'><span title='<%=ht.get("GUBUN")%>'><%=Util.subData(String.valueOf(ht.get("GUBUN")), 6)%></span></td>	
				    <td  width=100 align='center'><%=ht.get("FEE_TM")%>회차<%if(String.valueOf(ht.get("ALL_ST")).equals("Y")) out.println("이후모두");%></td>
					<td  width=160 align='center'><span title='<%=ht.get("B_VALUE")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("B_VALUE")), 22)%></span></td>					
					<td  width=160 align='center'><span title='<%=ht.get("A_VALUE")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("A_VALUE")), 22)%></span></td>
					<td  width=300>&nbsp;<span title='<%=ht.get("CNG_CAU")%>'><%=Util.subData(String.valueOf(ht.get("CNG_CAU")), 26)%></span></td>					
					<td  width=50 align='center'><%=ht.get("USER_NM")%></td>
					<td  width=130 align='center'><%=ht.get("CNG_DT")%></td>
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
    <tr>
		<td class='line' width='300' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1000'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>	
</table>
</form>
<script language='javascript'>
<!--
	//parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
