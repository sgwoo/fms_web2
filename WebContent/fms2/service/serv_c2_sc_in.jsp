<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	
	Vector vt = cr_db.getServConfList("2", s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, sort);
	int vt_size = vt.size();
	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
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
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>       
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/service/serv_c2_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='1020'>
    <tr>
      <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
	  <td class='line' width='300' id='td_title' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
		    <td width='30' class='title' style='height:45'>연번</td>			
			<td width='150' class='title'>정비업체</td>	
        	<td width='70' class='title'>정비일자</td>
		    <td width="50" class='title'>담당자</td>					
		  </tr>
		</table>
	  </td>
	  <td class='line' width='720'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<!--<td colspan="1" class='title'>문서결재</td>-->					  
			<td colspan="2" class='title' style='height:23'>기초사항</td>
			<td colspan="5" class='title'>정비사항</td>
			<td rowspan="2" width="150" class='title'>고객</td>
			<!--<td colspan="3" class='title'>지출방식</td>-->	
		  </tr>
		  <tr>
			<!--<td width='60' class='title'>청구자</td>-->
			<!--<td width='60' class='title'>확인자</td>-->
			<!--<td width='60' class='title'>관리자</td>-->									
			<!--<td width='60' class='title'>팀장</td>-->														  
			<td width='80' class='title'>차량번호</td>
			<td width='100' class='title'>차명</td>				  			
			<td width='60' class='title'>주행거리</td>	
			<td width='70' class='title'>정비분류</td>	
			<td width='80' class='title'>공임</td>					  
			<td width='80' class='title'>부품</td>					  
			<td width='100' class='title'>정비금액</td>			
			<!--<td width='120' class='title'>정산</td>-->					  
			<!--<td width='120' class='title'>출금</td>-->					  
			<!--<td width='120' class='title'>카드</td>-->					  
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
					<td  width='30' align='center'><%=i+1%></td>
					
					<td  width='150' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 11)%></span></td>										
					<td  width='70' align='center'><a href="javascript:parent.serv_action('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("SERV_ID")%>', '<%=ht.get("ACCID_ID")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SERV_DT")))%></a></td>
					<td  width='50' align='center'><%=ht.get("USER_NM")%></td>					
				</tr>
<%
		}
%>
				<tr>
				  <td class='title'>&nbsp;</td>				  
				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  
				</tr>
			</table>
		</td>
		<td class='line' width='720'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
					<!--<td  width='60' align='center'><%=ht.get("USER_NM1")%></td>-->
					<!--<td  width='60' align='center'><%=ht.get("USER_NM2")%></td>-->										
					<!--<td  width='60' align='center'><%=ht.get("USER_NM3")%></td>-->										
					<!--<td  width='60' align='center'><%=ht.get("USER_NM4")%></td>-->																								
					<td  width='80' align='center'><%=ht.get("CAR_NO")%></td>
					<td  width='100' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>					
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>					
					<td  width='70' align='center'><%=ht.get("SERV_ST_NM")%></td>					
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("R_LABOR")))%></td>							
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("R_AMT")))%></td>
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("REP_AMT")))%></td>
					<td  width='150' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>					
					<!--<td  width='120' align='center'><%=ht.get("PAY_ST4")%> <%=ht.get("PAY_DT4")%></td>-->																				
					<!--<td  width='120' align='center'><%=ht.get("PAY_ST1")%><%=ht.get("PAY_ST2")%> <%=ht.get("PAY_DT1")%><%=ht.get("PAY_DT2")%></td>-->					
					<!--<td  width='120' align='center'><%=ht.get("PAY_ST3")%> <%=ht.get("PAY_DT3")%></td>-->
				</tr>
<%
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("R_LABOR")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("R_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("REP_AMT")));
		}
%>
				<tr>
				  <!--<td class='title'>&nbsp;</td>-->
				  <!--<td class='title'>&nbsp;</td>-->				  				  
				  <!--<td class='title'>&nbsp;</td>-->				  				  				  
				  <!--<td class='title'>&nbsp;</td>-->				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>	
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <!--<td class='title'>&nbsp;</td>-->				  				  				  
				  <!--<td class='title'>&nbsp;</td>-->				  				  				  				  
				  <!--<td class='title'>&nbsp;</td>-->				  				  				  				  				  
				</tr>
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
		<td class='line' width='720'>
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
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

