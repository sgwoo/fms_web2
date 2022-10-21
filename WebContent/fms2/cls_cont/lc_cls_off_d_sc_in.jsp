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
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getClsDocList(s_kd, t_wd, gubun1, andor, "2");
	int vt_size = vt.size();
	
	String admin_yn = "";
	if(nm_db.getWorkAuthUser("전산담당",user_id)){
		admin_yn = "Y";
	}
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
		<td class='line' width='30%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr><td width='10%' class='title' style='height:51'>연번</td>
					<td width='10%' class='title'>구분</td>
		            <td width='25%' class='title'>계약번호</td>
        		    <td width='22%' class='title'>계약일</td>
		            <td width="33%" class='title'>고객</td>
		         	
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				    <td rowspan="2" class='title' width='8%' >차량번호</td>
				    <td rowspan="2" class='title' width='9%' >차량관리번호</td>		
				    <td rowspan="2" class='title' width='18%' >차명</td>	
				    <td rowspan="2" class='title' width='8%' >최초등록일</td>	
				    <td rowspan="2" class='title' width='8%'>해지일</td>				
				    <td colspan="2" class='title'>발신처</td>					
				    <td colspan="3" class='title'>수신처</td>
				   								
				</tr>
				<tr>
							  		  				  
				    <td width='9%' class='title'>기안자</td>
			        <td width='9%' class='title'>관리팀장<br>(지점장)</td>
			        <td width='9%' class='title'>회계관리</td>
			        <td width='13%' class='title'>채권관리</td>
			        <td width='9%' class='title'>총무팀장</td>
			     
					  
				
			    </tr>
			</table>
		</td>
    </tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='30%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String td_color = "";
				if(!String.valueOf(ht.get("USE_ST")).equals("진행")) td_color = "class='is'";

%>
				<tr>
					<td  <%=td_color%> width='10%' align='center'><%=i+1%>
					<%	if ( admin_yn.equals("Y")  )  { %> 	
					<a href="javascript:parent.cls_action_d( '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>');">D</a>
					<% } %>
					
					</td>
					<td  <%=td_color%> width='10%' align='center'><%=ht.get("BIT")%></td>
					<td  <%=td_color%> width='25%' align='center'><%=ht.get("RENT_L_CD")%></td>
					<td  <%=td_color%> width='22%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
					<td  <%=td_color%> width='33%'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>' ><%=AddUtil.substringbdot(String.valueOf(ht.get("FIRM_NM")), 16)%></span></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			String td_color = "";
			if(!String.valueOf(ht.get("USE_ST")).equals("진행")) td_color = "class='is'";
				
			String rent_start_dt 	= String.valueOf(ht.get("RENT_START_DT"));
							
%>			 
				<tr>
					<td  <%=td_color%> width='8%' align='center'><span title='메입옵션액  : <%=AddUtil.parseDecimal(String.valueOf(ht.get("OPT_AMT")))%>' ><%=ht.get("CAR_NO")%></span></td>					
					<td  <%=td_color%> width='9%' align='center'><%=ht.get("CAR_DOC_NO")%></td>					
					<td  <%=td_color%> width='18%' align='center'><span title='<%=ht.get("CAR_NM")%>' >
					<% if  (  String.valueOf(ht.get("FUEL_KD")).equals("8") ) { %><font color=red>[전]</font><% } %>&nbsp;<%=Util.subData(String.valueOf(ht.get("CAR_NM")), 12)%></span></td>		
					<td  <%=td_color%> width='8%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
					<td  <%=td_color%> width='8%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>													
					<td  <%=td_color%> width='9%' align='center'>
					  <!--기안자-->
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
					  <%	if(!user_id.equals(String.valueOf(ht.get("아마존카이외")))){%>
						<a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>', '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gian.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>', '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
					  <%}%></td>
					<!--관리 팀장-->  
					<td  <%=td_color%> width='9%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>					  
					  <a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>','<%=ht.get("BIT")%>', '2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>','<%=ht.get("BIT")%>', '2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID2")),"USER")%></a>
					  <%}%></td>
								
					<!--회계관리자-->
					<td  <%=td_color%> width='9%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT3")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)   || nm_db.getWorkAuthUser("해지관리자",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id)  ){%>
					  					  <a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>','3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>','3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%></a>
					  <%}%></td>
					<!--채권관리자 -->
					<td  <%=td_color%> width='13%' align='center'>
					 <% if(nm_db.getWorkAuthUser("매입옵션관리자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)   || nm_db.getWorkAuthUser("스케줄생성자",user_id)  || nm_db.getWorkAuthUser("전산팀",user_id) ){
							if(!String.valueOf(ht.get("USE_ST")).equals("해지") && String.valueOf(ht.get("BIT")).equals("완료") ) { %>
							해지				
					     <%}else{ %>
					     <% } %>
					  <%} %>
					 -<% if(nm_db.getWorkAuthUser("매입옵션관리자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)  || nm_db.getWorkAuthUser("스케줄생성자",user_id)   || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("보증보험담당자",user_id)   ){
							if(String.valueOf(ht.get("AUTODOC_YN")).equals("N") && String.valueOf(ht.get("BIT")).equals("완료") ) { %>
							회계				
					     <%}else{ %>					         
					     <% } %>
					  <%} %>
					-<% if(nm_db.getWorkAuthUser("매입옵션관리자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)  || nm_db.getWorkAuthUser("스케줄생성자",user_id)  || nm_db.getWorkAuthUser("전산팀",user_id) ||  nm_db.getWorkAuthUser("보증보험담당자",user_id)  ){
							if(!String.valueOf(ht.get("AUTODOC_YN")).equals("Y") && String.valueOf(ht.get("BIT")).equals("완료") ) { %>
							자산				
					     <%}else{ %>
					     <% } %>
					  <%} %>
					</td>
					<!--총무팀장-->  
					<td  <%=td_color%> width='9%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT5")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID5")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id)){%>
					  					  <a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>','5', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.cls_action( '<%=ht.get("TERM_YN")%>','<%=ht.get("BIT")%>','5', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID5")),"USER")%></a>
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
		<td class='line' width='30%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
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
