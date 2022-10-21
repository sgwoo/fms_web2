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
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	Vector vt = d_db.getClsDocList(s_kd, t_wd, gubun1, andor, "1",st_dt,end_dt);
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
<form name='form1' action='' method='post' target='d_content'>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='35%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr><td width='10%' class='title' style='height:51'>연번</td>
			    	<td width='7%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
					<td width='10%' class='title'>구분</td>
		            <td width='22%' class='title'>계약번호</td>
        		    <td width='18%' class='title'>계약일</td>
		            <td width="33%" class='title'>고객</td>
		         	
				</tr>
			</table>
		</td>
		<td class='line' width='65%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				    <td rowspan="2" class='title' width='13%'  >차량번호</td>		
				    <td rowspan="2" class='title' width='17%' >차명</td>	
				    <td colspan="2" class='title'>해지의뢰</td>				
				    <td colspan="2" class='title'>발신처</td>					
				    <td colspan="3" class='title'>수신처</td>
				   								
				</tr>
				<tr>
					<td width='10%' class='title'>해지일</td>				  		  				  
				    <td width='11%' class='title'>구분</td>
				    <td width='9%' class='title'>기안자</td>
			        <td width='10%' class='title'>관리팀장<br>(지점장)</td>
			        <td width='12%' class='title'>회계관리</td>
			        <td width='9%' class='title'>채권관리</td>
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
		<td class='line' width='35%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String td_color = "";
				if(String.valueOf(ht.get("USE_ST")).equals("해지")) td_color = "class='is'";

%>
				<tr>
					<td  <%=td_color%> width='10%' align='center'><%=i+1%>
<%	if ( admin_yn.equals("Y")  )  { %> 	
					<a href="javascript:parent.cls_action_d( '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>');">D</a>
<% } %>
					</td>
					<td <%=td_color%> width='7%' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%>"></td>  
					<td  <%=td_color%> width='10%' align='center'><%=ht.get("BIT")%></td>
					<td  <%=td_color%> width='22%' align='center'><%=ht.get("RENT_L_CD")%></td>
					<td  <%=td_color%> width='18%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
					<td  <%=td_color%> width='33%'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>' ><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 16)%></span></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='65%'>
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
					<td  <%=td_color%> width='13%' align='center'><%=ht.get("CAR_NO")%></td>		
					<td  <%=td_color%> width='17%' align='center'><span title='<%=ht.get("CAR_NM")%>' >
					<% if  (  String.valueOf(ht.get("FUEL_KD")).equals("8") ) { %><font color=red>[전]</font><% } %>&nbsp;<%=Util.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></td>		
						
					<td  <%=td_color%> width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>										
					<td  <%=td_color%> width='11%' align='center'><%=Util.subData(String.valueOf(ht.get("CLS_ST_NM")), 5)%></td>
					<td  <%=td_color%> width='9%' align='center'>
					  <!--기안자-->
					  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
					  <%	if(!user_id.equals(String.valueOf(ht.get("아마존카이외")))){%>
						<a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>', '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gian.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>', '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
					  <%}%></td>
					<!--관리 팀장-->  
					<td  <%=td_color%> width='10%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>					  
					  <a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>','<%=ht.get("BIT")%>', '2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>','<%=ht.get("BIT")%>', '2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID2")),"USER")%></a>
					  <%}%></td>
								
					<!--회계관리자-->
					<td  <%=td_color%> width='12%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT3")).equals("" ) ){%>
					  <%	if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사출납",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)  || nm_db.getWorkAuthUser("스케줄생성자",user_id)   ){%>
					  		  <a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>','3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
					  <%	}else{%>-<%}%>
					  <%}else{%><a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>','3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%></a>
					  <%}%>
					  <% if(nm_db.getWorkAuthUser("매입옵션관리자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id)  ||nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id)  ){											
						  if(!String.valueOf(ht.get("USE_ST")).equals("해지") && String.valueOf(ht.get("BIT")).equals("완료") ) { %>
							해지				
					     <%}else{ %>
					     <% } %>	
						 &nbsp;
						 <%if(String.valueOf(ht.get("AUTODOC_YN")).equals("N") && String.valueOf(ht.get("BIT")).equals("완료") ) { %>
							회계				
					     <%}else{ %>					         
					     <% } %>
					   
					   <% } %>  									  					  
					  </td>
					
					<!--채권관리자--> 
					<td  <%=td_color%> width='9%' align='center'>					
					 <% if ( ht.get("CLS_ST_NM").equals("출고전해지(신차)" ) || ht.get("CLS_ST_NM").equals("개시전해지(재리스)" )  ) {%>
					 - 
					 <% } else { %>
						  <%if (!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT4")).equals("") ) {%>
							  <%if ( String.valueOf(ht.get("USER_ID3")).equals( String.valueOf(ht.get("USER_ID4")))  ){%>
							   - 
							  <%} else { %>							   
								  <%	if(String.valueOf(ht.get("USER_ID4")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id) ){%>
								  					  <a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>','4', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
								  <%	}else{%>
								        -
								   <%   } %>
                              <% } %>	
						   <%} else {%><a href="javascript:parent.cls_action('<%=ht.get("TERM_YN")%>', '<%=ht.get("BIT")%>','4', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID4")),"USER")%></a>
						   <%}%>	  
						     
					  <% } %>
					  </td>
			
					<!--총무팀장-->  
					<td  <%=td_color%> width='9%' align='center'>
					  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT5")).equals("")){%>
					  <%	if(String.valueOf(ht.get("USER_ID5")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ){%>
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
		<td class='line' width='35%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='65%'>
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
</form>
</body>
</html>
