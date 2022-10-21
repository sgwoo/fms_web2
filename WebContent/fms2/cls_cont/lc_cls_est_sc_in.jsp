<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		
	Vector vt = ac_db.getClsEstDocList(s_kd, t_wd, gubun1, andor, "2");
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
	
	
	//정산서 인쇄
	function cls_print(m_id, l_cd ){
		
		var SUBWIN="lc_cls_est_print.jsp?rent_mng_id="+m_id + "&rent_l_cd="+l_cd;
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
				
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='27%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
			       <td width='14%' class='title' >연번</td>				
		            <td width='34%' class='title'>계약번호</td>
        		    <td width='27%' class='title'>계약일</td>
		           <td width='25%' class='title'>담당자</td>		         	
				</tr>
			</table>
		</td>
		<td class='line' width='73%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					 <td class='title' width='10%'>해지일</td>
					 <td class='title' width='10%'>구분</td>					
					 <td class='title' width='10%' >차량번호</td>		
				    <td class='title' width='16%' >차명</td>	
				  	 <td width="20%" class='title'>고객</td>			
				  	 <td width="15%" class='title'>사유</td>			
				  	 <td width="10%" class='title'>출력</td>				 
				  	 <td width="8%" class='title'>삭제</td>			 				 						
				</tr>
				
			</table>
		</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='27%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
		    	String td_color = "";
				if(!String.valueOf(ht.get("USE_ST")).equals("진행")) td_color = "class='is'";
				String m_id = String.valueOf(ht.get("RENT_MNG_ID"));
				String l_cd = String.valueOf(ht.get("RENT_L_CD"));

%>
				<tr>
					<td  <%=td_color%> width='14%' align='center'><%=i+1%></td>				
					 <td <%=td_color%> width='34%' align='center'>
	<% if (  !String.valueOf(ht.get("USE_ST")).equals("해지") ) {%>			 
				   <a href="javascript:parent.cls_action('<%=m_id%>', '<%=l_cd%>');">
	<% } %>			   
				   <%=l_cd%>
	<% if (  !String.valueOf(ht.get("USE_ST")).equals("해지") ) {%>				   
				   </a>
		<% } %>			 			   
				    </td>       
					
					<td <%=td_color%>  width='27%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>			
					<td <%=td_color%> width='25%' align='center'><%=ht.get("BUS_NM")%>	</td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='73%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			String td_color = "";
			if(!String.valueOf(ht.get("USE_ST")).equals("진행")) td_color = "class='is'";				
			
			String m_id = String.valueOf(ht.get("RENT_MNG_ID"));
			String l_cd = String.valueOf(ht.get("RENT_L_CD"));
							
%>			
				<tr>
					<td  <%=td_color%> width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>										
					<td  <%=td_color%> width='10%' align='center'><%=ht.get("CLS_ST_NM")%></td> 
					<td  <%=td_color%> width='10%' align='center'><%=ht.get("CAR_NO")%></td>		
					<td  <%=td_color%> width='16%' align='center'><span title='<%=ht.get("CAR_NM")%>' >				
					<% if  (  String.valueOf(ht.get("FUEL_KD")).equals("8") ) { %><font color=red>[전]</font><% } %>&nbsp;<%=Util.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>		
									
					<td  <%=td_color%> width='20%'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>' ><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 12)%></span></td>		
					<td  <%=td_color%> width='15%'>&nbsp;<span title='<%=ht.get("CLS_CAU")%>' ><%=Util.subData(String.valueOf(ht.get("CLS_CAU")), 10)%></span></td>		
				   <td <%=td_color%> width='10%' align='center'>&nbsp;
				   <a href="javascript:cls_print('<%=m_id%>', '<%=l_cd%>');"><img src=/acar/images/center/button_print_jss.gif align=absmiddle border=0></a>
			       </td>
			        <td <%=td_color%> width='8%' align='center'>&nbsp;
				   <a href="javascript:parent.cls_action_d('<%=m_id%>', '<%=l_cd%>');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
			       </td>
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
		<td class='line' width='27%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='73%'>
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
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
