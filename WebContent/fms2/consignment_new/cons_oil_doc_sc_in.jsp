<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
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
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = cs_db.getResCarOilReduceDocList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
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
<%@ include file="/acar/getNaviCookies.jsp" %>
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/consignment_new/cons_oil_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='1050'>
  <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='350' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='30' class='title' style='height:51'>연번</td>
		          <td width="40" class='title'>구분</td>				  
		          <td width='70' class='title'>거래일자</td>
				  <td width='140' class='title'>거래처명</td>
		          <td width="70" class='title'>금액</td>
				</tr>
			</table>
		</td>
		<td class='line' width='700'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="4" class='title'>결재</td>	
			      <td width='80' class='title' rowspan='2'>비용담당자</td>
			      <td width='370' class='title' rowspan='2'>비용내역</td>
			    </tr>
				<tr>
				  <td width='70' class='title'>기안일자</td>				
				  <td width='60' class='title'>기안자</td>
			      <td width='60' class='title'>팀장</td>
				  <td width='60' class='title'>처리구분</td>
			  </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='350' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='40' align='center'><%=ht.get("ST_NM")%></td>															
					<td  width='70' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_DT")))%></td>					
					<td  width='140' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 10)%></td>
					<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>					

				</tr>
<%		}%>
				<tr>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>				  
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				</tr>
			</table>
		</td>
		<td class='line' width='700'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>								
					<td  width='70' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USER_DT1")))%></td>												
					<td  width='60' align='center'>
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
					  <a href="javascript:parent.doc_action('<%=ht.get("ST")%>', '<%=ht.get("M_DOC_CODE")%>', '<%=ht.get("SEQ1")%>', '<%=ht.get("SEQ2")%>', '<%=ht.get("BUY_USER_ID")%>', '1', '<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>
					  <%}else{%>
					  <a href="javascript:parent.doc_action('<%=ht.get("ST")%>', '<%=ht.get("M_DOC_CODE")%>', '<%=ht.get("SEQ1")%>', '<%=ht.get("SEQ2")%>', '<%=ht.get("BUY_USER_ID")%>', '1', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM1")%></a>
					  <%}%>
					</td>
					<td  width='60' align='center'>					
					  <%if(String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
					  <a href="javascript:parent.doc_action('<%=ht.get("ST")%>', '<%=ht.get("M_DOC_CODE")%>', '<%=ht.get("SEQ1")%>', '<%=ht.get("SEQ2")%>', '<%=ht.get("BUY_USER_ID")%>', '2', '<%=ht.get("DOC_NO")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
					  <%	}else{%>-<%}%>
					  <%}else{%>
					  <a href="javascript:parent.doc_action('<%=ht.get("ST")%>', '<%=ht.get("M_DOC_CODE")%>', '<%=ht.get("SEQ1")%>', '<%=ht.get("SEQ2")%>', '<%=ht.get("BUY_USER_ID")%>', '2', '<%=ht.get("DOC_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM2")%></a>
					  <%}%>
					</td>
					<td  width='60' align='center'><%=ht.get("INS_DOC_ST_NM")%></td>					
					<td  width='80' align='center'><%=ht.get("BUY_USER_NM")%></td>
					<td  width='370'>&nbsp;<span title='<%=ht.get("AMT_CONT")%>'><%=Util.subData(String.valueOf(ht.get("AMT_CONT")), 35)%></td>
				</tr>
<%		}%>
				<tr>											
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>										
				</tr>
			</table>
		</td>
<%	}else{%>
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
		<td class='line' width='700'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
