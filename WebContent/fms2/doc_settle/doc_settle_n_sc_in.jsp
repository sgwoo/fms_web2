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
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

 //	System.out.println("gubun2=" + gubun2);
 		
	Vector vt = d_db.getDocSettleUserList(s_kd, t_wd, gubun1, gubun2, gubun3, start_dt, end_dt);
	int vt_size = vt.size();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&start_dt="+start_dt+"&end_dt="+end_dt+
				   	"&sh_height="+sh_height+"";
				   	
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
	
	//의뢰자 변경
	function doc_id_cng(doc_no, doc_bit, doc_user){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 300;		
		window.open("doc_user_cng.jsp<%=valus%>&doc_no="+doc_no+"&doc_bit="+doc_bit+"&doc_user="+doc_user, "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
	
	//메신저발송
	function cool_msg_send(doc_no){
		var fm = document.form1;	
		var width 	= 600;
		var height 	= 400;		
		window.open("doc_cool_msg_send.jsp<%=valus%>&doc_no="+doc_no, "MSG_SEND", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
		
	//문서 취소
	function doc_del(doc_no){
		var fm = document.form1;	
		
		if(confirm('삭제하시겠습니까?')){
		if(confirm('진짜로 삭제하시겠습니까?')){		
			fm.doc_no.value = doc_no;
			fm.action='doc_cancel_a.jsp';
			fm.target='i_no';
			fm.submit();
		}}
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
<%@ include file="/acar/getNaviCookies.jsp" %>
<body onLoad="javascript:init()">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='start_dt' 	value='<%=start_dt%>'>    
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='doc_no' 	value=''>
  <input type='hidden' name='user_st' 	value=''>
  <table border="0" cellspacing="0" cellpadding="0" width='1770'>
  <tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='580' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
					<tr>
								<td width='40' class='title'>연번</td>
								<td width='40' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		            <td width="40" class='title'>상태</td>
		            <td width="60" class='title'>메시지</td>
		            <td width="100" class='title'>구분</td>
								<td width='100' class='title'>문서번호</td>
   		    			<td width='100' class='title'>제목</td>
   		    			<td width='100' class='title'>내용</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1190'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		   		    <td width='100' class='title'>고객</td>
		   		    <td width='100' class='title'>차명</td>
					<td width='100' class='title'>결재자1</td>
					<td width='100' class='title'>결재자2</td>
					<td width='100' class='title'>결재자3</td>
					<td width='100' class='title'>결재자4</td>
					<td width='100' class='title'>결재자5</td>
					<td width='100' class='title'>결재자6</td>
					<td width='100' class='title'>결재자7</td>
					<td width='100' class='title'>결재자8</td>
					<td width='100' class='title'>결재자9</td>
					<td width='90' class='title'>-</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='580' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='40' align='center'><%=i+1%></td>
					<td  width='40' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("DOC_NO")%>"></td>
					<td  width='40' align='center'>&nbsp;<br><%=ht.get("DOC_STEP_NM")%><br>&nbsp;</td>
					<td  width='60' align='center'>
					<%if(String.valueOf(ht.get("DOC_STEP_NM")).equals("미결")){ %>
					<a href="javascript:cool_msg_send('<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_msg.gif" border="0" align=absmiddle></a>
					<%}%>
					</td>					
					<td  width='100' align='center'>&nbsp;<br><%=ht.get("DOC_ST_NM")%><br>&nbsp;</td>
					<td  width='100' align='center'>					
					<% if(ht.get("DOC_ST").equals("8")){%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','8')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>
					<%}else if(ht.get("DOC_ST").equals("9")) {%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','9')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>	
					<%}else if(ht.get("DOC_ST").equals("21")) {%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','21')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>
					<%}else if(ht.get("DOC_ST").equals("22")) {%>	
						<a href="javascript:parent.view_doc2('<%=ht.get("USER_ID1")%>','<%=ht.get("DOC_ID")%>','22')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>	
					<%}else{%>
						<a href="javascript:parent.view_doc('<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_ST")%>','<%=ht.get("DOC_ID")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_BIT")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_NO")%></a>
					<%}%>
					</td>
					<td  width='100'>&nbsp;<span title='<%=ht.get("SUB")%>'><%=Util.subData(String.valueOf(ht.get("SUB")), 6)%></span></td>
					<td  width='100'>&nbsp;<span title='<%=ht.get("CONT")%>'><%=Util.subData(String.valueOf(ht.get("CONT")), 6)%></span>					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1190'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>			
				<tr>
					<td  width='100'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
					<td  width='100'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID1")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM1") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT1") %>&nbsp;<%}%></td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID2")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM2") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID2")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT2") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT2")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ) && !String.valueOf(ht.get("USER_ID2")).equals("")  && !String.valueOf(ht.get("USER_ID2")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','2', '<%=ht.get("USER_ID2")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID3")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM3") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT3") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT3")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ) && !String.valueOf(ht.get("USER_ID3")).equals("")  && !String.valueOf(ht.get("USER_ID3")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','3', '<%=ht.get("USER_ID3")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID4")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM4") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID4")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT4") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT4")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ) && !String.valueOf(ht.get("USER_ID4")).equals("")  && !String.valueOf(ht.get("USER_ID4")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','4', '<%=ht.get("USER_ID4")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID5")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM5") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID5")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT5") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT5")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ) && !String.valueOf(ht.get("USER_ID5")).equals("")  && !String.valueOf(ht.get("USER_ID5")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','5', '<%=ht.get("USER_ID5")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID6")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM6") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID6")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT6") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT6")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ) && !String.valueOf(ht.get("USER_ID6")).equals("")  && !String.valueOf(ht.get("USER_ID6")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','6', '<%=ht.get("USER_ID6")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID7")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM7") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID7")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT7") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT7")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ) && !String.valueOf(ht.get("USER_ID7")).equals("")  && !String.valueOf(ht.get("USER_ID7")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','7', '<%=ht.get("USER_ID7")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID8")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM8") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID8")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT8") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT8")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)  || nm_db.getWorkAuthUser("해지관리자",user_id) ) && !String.valueOf(ht.get("USER_ID8")).equals("")  && !String.valueOf(ht.get("USER_ID8")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','8', '<%=ht.get("USER_ID8")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID9")).equals("")){ %><span style="text-decoration:underline"><%=ht.get("USER_NM9") %></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID9")),"USER") %></font>&nbsp;<br><%=ht.get("USER_DT9") %>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT9")).equals("")  && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)) && !String.valueOf(ht.get("USER_ID9")).equals("")  && !String.valueOf(ht.get("USER_ID9")).equals("XXXXXX")){ %>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','9', '<%=ht.get("USER_ID9")%>' );">[변경]</a>
					<%}%>
					</td>
					<td  width='100' align='center'><%if(!String.valueOf(ht.get("USER_ID10")).equals("")){%><span style="text-decoration:underline"><%=ht.get("USER_NM10")%></span><br><font color=green><%=c_db.getNameById(String.valueOf(ht.get("USER_ID10")),"USER")%></font>&nbsp;<br><%=ht.get("USER_DT10")%>&nbsp;<%}%>
					<%if(String.valueOf(ht.get("USER_DT10")).equals("") && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업담당자변경",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id)) && !String.valueOf(ht.get("USER_ID10")).equals("") && !String.valueOf(ht.get("USER_ID10")).equals("XXXXXX")){%>
					<a href="javascript:doc_id_cng('<%=ht.get("DOC_NO")%>','10','<%=ht.get("USER_ID10")%>');">[변경]</a>
					<%}%>
					<%if(nm_db.getWorkAuthUser("전산팀",user_id)){%><a href="javascript:doc_del('<%=ht.get("DOC_NO")%>','', '' );">[취소]</a><%}%>
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
		<td class='line' width='580' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1190'>
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
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
