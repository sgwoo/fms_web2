<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	
	Vector vt = a_db.getCarPurCouPonList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
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
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
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
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_coupon_frame.jsp'>
  <input type='hidden' name='doc_no' value=''>
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width='1380'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='350' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
					<td width="40" class='title'>연번</td>				
					<td width="40" class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
				    <td width=120 class='title'>계출번호</td>
				    <td width=150 class='title'>차대번호</td>					
	            </tr>
			</table>
		</td>
		<td class='line' width='1030'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		            <td width=100 class='title'>제조사</td>				
		            <td width=150 class='title'>출고영업소</td>
		            <td width=80 class='title'>출고일자</td>				
				    <td width=80 class='title'>지점</td>				
				    <td width=100 class='title'>쿠폰구분</td>
				    <td width=80 class='title'>쿠폰수령일</td>
					<td width=60 class='title'>수령자</td>
			        <td width=80 class='title'>쿠폰지급일</td>					
					<td width=100 class='title'>일련번호</td>					
				    <td width=100 class='title'>협력업체</td>					
			        <td width=100 class='title'>계약번호</td>					
				</tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='350' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td width="40" align='center'><%=i+1%></td>
					<td width="40" align='center'><%if(String.valueOf(ht.get("COM_TINT_COUPON_PAY_DT")).equals("") && !String.valueOf(ht.get("COM_TINT_COUPON_DT")).equals("")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%>"><%}else{%>-<%}%></td>					
					<td  width=120 align='center'><%=ht.get("RPT_NO")%></td>
					<td  width=150 align='center'><%=ht.get("CAR_NUM")%></td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1030'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
					<td  width=100 align='center'><%=ht.get("CAR_COMP_NM")%></td>
					<td  width=150 align='center'><%=ht.get("CAR_OFF_NM")%></td>					
					<td  width=80 align='center'>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>									
				    <td  width=80 align='center'><%=ht.get("BR_NM")%></td>
					<td  width=100 align='center'><%=ht.get("COM_COUPON_NM")%></td>
				    <td  width=80 align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("COM_TINT_COUPON_DT")))%></td>
					<td  width=60 align='center'><%=ht.get("COUPON_REG_NM")%>
					<%if(String.valueOf(ht.get("COM_TINT_COUPON_DT")).equals("") || String.valueOf(ht.get("COM_TINT_COUPON_REG_ID")).equals("")){%>
					<a href="javascript:parent.reg_coupon('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					<%}%>
					</td>
					<td  width=80 align='center'><a href="javascript:parent.pay_coupon_print('<%=ht.get("COM_TINT_COUPON_PAY_DT")%>','<%=ht.get("OFF_NM")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("COM_TINT_COUPON_PAY_DT")))%></a></td>														    					
				    <td  width=100 align='center'><%=ht.get("COM_TINT_COUPON_NO")%></td>					
					<td  width=100 align='center'><span title='<%=ht.get("OFF_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("OFF_NM")), 5)%></span></td>
					<td  width=100 align='center'><%=ht.get("RENT_L_CD")%></td>
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
		<td class='line' width='350' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1030'>
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
