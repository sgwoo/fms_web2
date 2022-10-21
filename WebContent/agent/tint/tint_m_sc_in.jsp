<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = t_db.getTintMngList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
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
<form name='form1' method='post'>
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
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/agent/tint/tint_m_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='2000'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='300' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
		    		<td width='60' class='title' style='height:45'>연번</td>
		    		<td width='100' class='title'>용품업체</td>			
        			<td width='80' class='title'>요청등록일</td>
		    		<td width="60" class='title'>의뢰자</td>					
				</tr>
			</table>
		</td>
		<td class='line' width='1700'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="4" class='title'>기초사항</td>
				  <td colspan="11" class='title'>용품요청</td>				  
		          <td rowspan="2" width="150" class='title'>고객</td>				  
				</tr>
				<tr>
			      <td width='150' class='title'>차명</td>				  
			      <td width='120' class='title'>계출번호</td>				  				  			  				  
			      <td width='150' class='title'>차대번호</td>				  				  			  				  
			      <td width='80' class='title'>색상</td>	
				  <td width='110' class='title'>마감요청일시</td>
				  <td width='110' class='title'>작업마감일시</td>
				  <td width='80' class='title'>청구일자</td>
				  <td width='80' class='title'>지급일자</td>	
				  <td width='100' class='title'>제조사</td>				
				  <td width='100' class='title'>썬팅</td>				  
				  <td width='100' class='title'>청소함</td>					  
				  <td width='100' class='title'>네비</td>	
				  <td width='70' class='title'>블랙박스</td>				  
				  <td width='100' class='title'>기타</td>
				  <td width='100' class='title'>견적반영용품</td>				
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
					<td  width='60' align='center'><%=i+1%></td>
					<td  width='100' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td  width='60' align='center'><%=ht.get("REG_NM")%></td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1700'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
					<%if(String.valueOf(ht.get("TINT_ST")).equals("2")){%>
					<td  colspan="4" align='center'><a href="javascript:parent.tint_action('<%=ht.get("TINT_NO")%>');"><span title='<%=ht.get("ETC")%>'><%=Util.subData(String.valueOf(ht.get("ETC")), 30)%></span></a></td>
					<%}else{%>
					<td  width='150' align='center'><a href="javascript:parent.tint_action('<%=ht.get("TINT_NO")%>');"><span title='<%=ht.get("CAR_NM2")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM2")), 12)%></span></a></td>
					<td  width='120' align='center'><%=ht.get("RPT_NO")%></td>			
					<td  width='150' align='center'><%=ht.get("CAR_NUM2")%></td>
					<td  width='80' align='center'><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 5)%></span></td>
					<%}%>
					<td  width='110' align='center'><a href="javascript:parent.tint_action('<%=ht.get("TINT_NO")%>');"><font color=red><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_EST_DT")))%></font></a></td>
					<td  width='110' align='center'><font color=red><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_DT")))%></font></td>
					<td  width='80' align='center'><font color=red><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></font></td>
					<td  width='80' align='center'><font color=red><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%></font></td>					
					<td width='100' align='center'>
					<%if(String.valueOf(ht.get("TINT_CAU")).equals("1")){%>
					<%=ht.get("COM_TINT_NM")%>
					<%}%>
					</td>		
					<td width='70' align='center'>
					<%if(String.valueOf(ht.get("COM_FILM_ST_NM")).equals("")){%>
					<%=ht.get("FILM_ST_NM")%>
					<%}else{%>
					<%=ht.get("COM_FILM_ST_NM")%>
					<%}%>
					</td>		
					<td  width='30' align='center'><%=ht.get("SUN_PER")%>%</td>							
					<td  width='100' align='center'><%=ht.get("CLEANER_ST_NM")%></td>
					<td  width='100' align='center'><span title='<%=ht.get("NAVI_NM")%>'><%=Util.subData(String.valueOf(ht.get("NAVI_NM")), 6)%></span></td>
					<td  width='70' align='center'><%=ht.get("BLACKBOX_YN_NM")%>
					    <%if(!String.valueOf(ht.get("BLACKBOX_IMG")).equals("")){%>
                                                <img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0">
                                            <%}%>
                                            <%if(!String.valueOf(ht.get("BLACKBOX_IMG2")).equals("")){%>
                                                <img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0">
                                            <%}%>
					</td>
					<td  width='100' align='center'><span title='<%=ht.get("OTHER")%>'><%=Util.subData(String.valueOf(ht.get("OTHER")), 6)%></span></td>
					<td  width='100' align='center'><span title='<%=ht.get("TINT_BSN_YN")%>'><%=Util.subData(String.valueOf(ht.get("TINT_BSN_YN")), 6)%></span></td>
					<td  width='150' align='center'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 10)%><span title='<%=ht.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"></a></span></td>					
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
		<td class='line' width='1700'>
			<table border="0" cellspacing="1" cellpadding="0" width='1160'>
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

