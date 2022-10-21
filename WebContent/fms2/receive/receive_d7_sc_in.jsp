<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
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
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	Vector vt = re_db.getClsBandDocList(s_kd, t_wd, gubun1, andor, "1");
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
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='34%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr><td width='10%' class='title' style='height:51'>연번</td>				
		            <td width='20%' class='title'>계약번호</td>
        		  	<td width='20%' class='title'>계약일</td>
		            <td width="35%" class='title'>고객</td>		         	
				</tr>
			</table>
		</td>
		<td class='line' width='66%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				    <td rowspan="2" class='title' width='9%'  style='height:51'>차량번호</td>		
				    <td rowspan="2" class='title' width='18%' >차명</td>	
				    <td rowspan="2" class='title'  width='8%'>의뢰일</td>		
				       <td colspan="2" class='title'>해지</td>				
				    <td colspan="2" class='title'>요청</td>		
				    <td colspan="2" class='title'>결과</td>			
				  									
				</tr>
				<tr>	
					<td width='8%' class='title'>해지일</td>
				    <td width='14%' class='title'>구분</td>			
				    <td width='9%' class='title'>기안자</td>
			    	<td width='9%' class='title'>팀장</td>	
			    	<td width='9%' class='title'>기안자</td>
			    	<td width='9%' class='title'>팀장</td>	
			    						
			    </tr>
			</table>
		</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='34%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String td_color = "";
				if(String.valueOf(ht.get("USE_ST")).equals("해지")) td_color = "class='is'";

%>
				<tr>
					<td  <%=td_color%> width='10%' align='center'><%=i+1%></td>				
					<td  <%=td_color%> width='20%' align='center'><a href="javascript:parent.action_u( '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');"><%=ht.get("RENT_L_CD")%></a></td>
					<td  <%=td_color%> width='20%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
					<td  <%=td_color%> width='35%'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>' ><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 16)%></span></td>				
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='66%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			String td_color = "";
			if(String.valueOf(ht.get("USE_ST")).equals("해지")) td_color = "class='is'";
				
			String rent_start_dt 	= String.valueOf(ht.get("RENT_START_DT"));
							
%>			
				<tr>
					<td  <%=td_color%> width='9%' align='center'><%=ht.get("CAR_NO")%></td>		
					<td  <%=td_color%> width='18%' align='center'><%=ht.get("CAR_NM")%></td>		
					<td  <%=td_color%> width='8%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
					<td  <%=td_color%> width='8%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
					<td  <%=td_color%> width='14%' align='center'><%=ht.get("CLS_ST_NM")%></td>	
					<td  <%=td_color%> width='9%' align='center'>
					  <!--진행  기안자-->
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>					
						<a href="javascript:parent.action( '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gian.gif"  border="0" align=absmiddle></a>
					 <%}else{%><a href="javascript:parent.action( '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
					  <%}%></td>
					<!-- 팀장-->  
					<td  <%=td_color%> width='9%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>					  
					  <a href="javascript:parent.action( '2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.action( '2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID2")),"USER")%></a>
					  <%}%></td>
					  <td  <%=td_color%> width='9%' align='center'>
					  <!--결과 기안자-->
					 <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT3")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>					  
					  <a href="javascript:parent.action( '3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.action( '3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%></a>
					  <%}%></td>
					<!-- 팀장-->  
					<td  <%=td_color%> width='9%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT4")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID4")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>					  
					  <a href="javascript:parent.action( '4', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.action( '4', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID4")),"USER")%></a>
					  <%}%></td>	  
				
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
		<td class='line' width='34%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='66%'>
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
