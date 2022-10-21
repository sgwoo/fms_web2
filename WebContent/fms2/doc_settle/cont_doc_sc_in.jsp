<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String agent_id = ck_acar_id;
	
	if(!acar_de.equals("1000")) agent_id = "";
	
	Vector vt = d_db.getContCngDocList(s_kd, t_wd, gubun1, agent_id);
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/doc_settle/cont_doc_frame.jsp'>
  <input type='hidden' name='doc_print_type' value=''>
  
  <table border="0" cellspacing="0" cellpadding="0" width='1320'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='480' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
					<tr>
					<td width='40' class='title' style='height:45'>연번</td>
				    <td width=30 class='title'>선택</td>
					<td width='50' class='title'>&nbsp;<br>구분<br>&nbsp;</td>
		            <td width='110' class='title'>계약번호</td>
		            <td width="150" class='title'>고객</td>
		            <td width="100" class='title'>차량번호</td>					
				</tr>
			</table>
		</td>
		<td class='line' width='840'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		          <td width='150' rowspan="2" class='title'>차명</td>				
				  <td colspan="3" class='title'>결재</td>					
		          <td width='150' rowspan="2" class='title'>변경항목</td>
		          <td width='200' rowspan="2" class='title'>특이사항</td>
		          <td width='120' rowspan="2" class='title'>등록</td>
				</tr>
				<tr>
				  <td width='80' class='title'>기안일자</td>								  
				  <td width='70' class='title'>부서</td>								  
				  <td width='70' class='title'>기안자</td>
			      
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='480' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='40' align='center'><%=i+1%></td>
					<td  width=30 align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("INS_DOC_NO")%>"></td>
					<td  width='50' align='center'><%=ht.get("BIT")%></td>
					<td  width='110' align='center'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
					<td  width='150'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>
					<td  width='100' align='center'><%=ht.get("CAR_NO")%></td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='840'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
					<td  width='150'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>				
					<td  width='80' align='center'><%=ht.get("USER_DT1")%></td>										
					<td  width='70' align='center'><%=ht.get("DEPT_NM")%></td>					
					<td  width='70' align='center'>
					  <!--기안자-->
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
					  <%	if(!user_id.equals(String.valueOf(ht.get("아마존카이외")))){%>
					  <a href="javascript:parent.doc_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("INS_ST")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("INS_DOC_NO")%>','<%=ht.get("DOC_BIT")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a>
					  <%	}else{%>
					  -
					  <%	}%>
					  <%}else{%>
					  <a href="javascript:parent.doc_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("INS_ST")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("INS_DOC_NO")%>','<%=ht.get("DOC_BIT")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
					  <%}%>
					</td>					
					<td  width='150'>&nbsp;<span title='<%=ht.get("CH_ITEM")%>'><%=Util.subData(String.valueOf(ht.get("CH_ITEM")), 10)%></span></td>  
					<td  width='200'>&nbsp;<span title='<%=ht.get("ETC")%>'><%=Util.subData(String.valueOf(ht.get("ETC")), 15)%></span></td>                                         
					<td  width='120' align='center'><%=ht.get("REG_DT")%> <%=ht.get("REG_NM")%></td>
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
		<td class='line' width='480' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='840'>
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
