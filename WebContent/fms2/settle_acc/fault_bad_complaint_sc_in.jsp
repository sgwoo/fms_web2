<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.inside_bank.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw") == null ? ""  : request.getParameter("auth_rw");
	String user_id  = request.getParameter("user_id")  == null ? ""  : request.getParameter("user_id");
	String br_id 	 = request.getParameter("br_id")	   == null ? ""  : request.getParameter("br_id");
	
	String s_kd 	 = request.getParameter("s_kd")      == null ? "3" : request.getParameter("s_kd");
	String t_wd 	 = request.getParameter("t_wd")      == null ? ""  : request.getParameter("t_wd");
	String andor 	 = request.getParameter("andor")     == null ? "1" : request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")   == null ? ""  : request.getParameter("gubun1");
	
	int sh_height = request.getParameter("sh_height") == null ? 0 : Util.parseInt(request.getParameter("sh_height"));	// 상단길이
	
	int count =0;
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getFaultBadComplaintList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<script language='javascript'>
	// 	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	}
	
	function init(){
		setupEvents();
	}
	
	
	function deleteReq(car_mng_id, accid_id) {
		if (confirm("해당 요청을 삭제 하시겠습니까?") == true) {
			var fm = document.form1;
			var gubun1 = fm.gubun1.value;
			
			location.href = 'fault_bad_complaint_a.jsp?car_mng_id='+car_mng_id+'&accid_id='+accid_id+'&gubun1='+gubun1;
		} else {
			return;			
		}
	}	
	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<form name='form1' method='post'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<body onLoad="javascript:init()">
	<table border="0" cellspacing="0" cellpadding="0" width='1680'>
	    <tr>
	        <td colspan="2" class=line2></td>
	    </tr>
		<tr id='tr_title' style='position:relative;z-index:1'>
			<td class='line' width='770' id='td_title' style='position:relative;'>
				<table border="0" cellspacing="1" cellpadding="0" width='100%'>
					<tr>
					    <td width='30' class='title' style='height:45'>연번</td>
					    <td width='40' class='title'>구분</td>
					    <td width="120" class='title'>계약번호</td>
			            <td width="230" class='title'>고객</td>
			            <td width="80" class='title'>차량번호</td>
			            <td width="140" class='title'>차명</td>
			            <td width="150" class='title'>사고일시</td>
					</tr>
				</table>
			</td>
			<td class='line' width='910'>
				<table border="0" cellspacing="1" cellpadding="0" width='100%'>
					<tr>
					  <td width="80" rowspan=2 class='title'>요청일</td>			
					  <td colspan="4" class='title'>진행결재</td>					
					  <td colspan="2" class='title'>결과결재</td>
					  <td colspan="2" class='title'>접수처리</td>
					</tr>
					<tr>					
					  <td width='80' class='title'>기안자</td>
					  <td width='100' class='title'>고객지원팀장</td>
					  <td width='80' class='title'>법무담당</td>
					  <td width='80' class='title'>총무팀장</td>					
					  <td width='80' class='title'>법무담당</td>
					  <td width='80' class='title'>총무팀장</td>
					  <td width='250' class='title'>요청사유</td>
					  <td width='80' class='title'>삭제</td>
				    </tr>
				</table>
			</td>
		</tr>
		
	<%
		if(vt_size > 0)
		{
	%>
		<tr>
			<td class='line' width='770' id='td_con' style='position:relative;'>
				<table border="0" cellspacing="1" cellpadding="0" width='100%'>
	<%
			for(int i = 0 ; i < vt_size ; i++)
			{
				Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
					<tr>
						<td  width='30' align='center'><%=i+1%></td>
						<td  width='40' align='center'><%=ht.get("BIT")%></td>	
						<td  width='120' align='center'><%=ht.get("RENT_L_CD")%></td>	
						<td  width='230'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 20)%></span></td>					
						<td  width='80' align='center'><%=ht.get("CAR_NO")%></td>
						<td  width='140'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 12)%></span></td>					
						<td  width='150' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("ACCID_DT")))%></td>
					</tr>
	<%
			}
	%>
				</table>
			</td>
			<td class='line' width='910'>
				<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<%
					for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
				%>			
					<tr>
	                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>					
						<td  width='80' align='center'>
							<!--기안자-->
							<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');"><%=ht.get("USER_NM1")%></a>
						</td>
						<td  width='100' align='center'>
							<!--고객지원팀장-->
							<% if(String.valueOf(ht.get("USER_DT2")).equals("")){ %>
							<% if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)  ){ %>
							<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
							<%	}else{%>-<%}%>
							<%}else{%><a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');"><%=ht.get("USER_NM2")%></a>
							<%}%>
						</td>
						<td  width='80' align='center'>
							<!--법무담당-->
							<% if(String.valueOf(ht.get("USER_DT3")).equals("")){ %>
							<% if((String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && !String.valueOf(ht.get("BIT")).equals("완료")){%>		
								<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
							<%	}else{%>-<%}%>
							<%}else{%><a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');"><%=ht.get("USER_NM3")%></a>
							<%}%>
						</td>
						<td  width='80' align='center'>
						  	<!--총무팀장-->
							<% if(String.valueOf(ht.get("USER_DT4")).equals("")){%>
							<% if((String.valueOf(ht.get("USER_ID4")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && !String.valueOf(ht.get("BIT")).equals("완료")){%>
								<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');" onMouseOver="window.status=''; return true">
									<img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0">
								</a>
							<% } else{%>-<%}%>
							<% } else{%>
								<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');"><%=ht.get("USER_NM4")%></a>
							<% }%>
						</td>
						<td  width='80' align='center'>
							<!--법무담당-->
							<% if(String.valueOf(ht.get("USER_DT5")).equals("")){ %>
							<% if((String.valueOf(ht.get("USER_ID5")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && !String.valueOf(ht.get("BIT")).equals("완료")){ %>
							<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
							<%	}else{%>-<%}%>
							<%}else{%><a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');"><%=ht.get("USER_NM5")%></a>
							<%}%>
						</td>
						<td  width='80' align='center'>
						  	<!--총무팀장-->
							<% if(String.valueOf(ht.get("USER_DT6")).equals("")){%>
							<% if((String.valueOf(ht.get("USER_ID6")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)) && !String.valueOf(ht.get("BIT")).equals("완료")){%>
								<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');" onMouseOver="window.status=''; return true">
									<img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0">
								</a>
							<% } else{%>-<%}%>
							<% } else{%>
								<a href="javascript:parent.doc_action('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>','<%=i%>', '14');"><%=ht.get("USER_NM6")%></a>
							<% }%>
						</td>
						<td  width='250'>&nbsp;<span title='<%=ht.get("REQ_REM")%>'><%=Util.subData(String.valueOf(ht.get("REQ_REM")), 20)%></span></td>
						<td  width='80'align='center'>
						<% if(String.valueOf(ht.get("USER_DT4")).equals("")) {%>
						<% if((nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("채권관리팀",user_id)) && !String.valueOf(ht.get("BIT")).equals("완료")  ){%>						
						<a href="javascript:deleteReq('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("ACCID_ID")%>');" title='요청삭제' ><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
						<%}%>
						<%}%>
						</td>
					</tr>
				<%
					}
				%>
				</table>
			</td>
		<%	}                  
			else {
		%>                     
		<tr>
			<td class='line' width='770' id='td_con' style='position:relative;'>
				<table border="0" cellspacing="1" cellpadding="0" width='100%'>
					<tr>
						<td align='center'>
							<%if(t_wd.equals("")){%>검색어를 입력하십시오.
							<%}else{%>등록된 데이타가 없습니다<%}%>
						</td>
					</tr>
				</table>
			</td>
			<td class='line' width='910'>
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
</form>
</html>

