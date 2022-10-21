<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.common.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="p_bean" class="acar.off_anc.PropBean" scope="page"/>
<jsp:useBean id="pc_bean" class="acar.off_anc.PropCommentBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	int prize =0;
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&asc="+asc+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_width="+s_width+"&s_height="+s_height;
	
	
	
	int prop_id = request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	String s_prop_id = request.getParameter("prop_id")==null?"":request.getParameter("prop_id");
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	int cnt1 = 0; // 찬성
	int cnt2 = 0; // 반대
	int cnt3 = 0; // 기권
	int tot = 0;
	int tot2 = 0;
	
	int su = request.getParameter("idx")==null?0:Util.parseInt(request.getParameter("idx"));
	
	String N_id = request.getParameter("N_id")==null?"":request.getParameter("N_id");
	String B_id = request.getParameter("B_id")==null?"":request.getParameter("B_id");
	
	Vector vt = p_db.getOffPropList(s_kd, t_wd, gubun1, st_dt, end_dt, gubun2, gubun3, gubun4, user_id);
	int vt_size = vt.size();
	String p_id[] = new String[vt_size];
	
	int pid_num = 0;

	
	Hashtable next_ht = new Hashtable();
	Hashtable back_ht = new Hashtable();
	
	if(vt_size > 1){
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		p_id[i] = String.valueOf(ht.get("PROP_ID"));
	
		if(prop_id == AddUtil.parseInt(String.valueOf(ht.get("PROP_ID")))){
		
			pid_num = i;
			
			
			if(i==0){				
				back_ht = (Hashtable)vt.elementAt(i+1);			
				back_ht.put("IDX", String.valueOf(i+1+1));
			}else if(i+1==vt_size){
				next_ht = (Hashtable)vt.elementAt(i-1);	
				next_ht.put("IDX", String.valueOf(i-1+1));					
			}else{
				next_ht = (Hashtable)vt.elementAt(i-1);
				back_ht = (Hashtable)vt.elementAt(i+1);
				back_ht.put("IDX", String.valueOf(i+1+1));
				next_ht.put("IDX", String.valueOf(i-1+1));					

			}
		}
	}
	}
	

	
	p_bean = p_db.getPropBean(prop_id);
	
	//댓글리스트
	PropCommentBean pc_r [] = p_db.getPropCommentList(prop_id);
	
	Vector users = c_db.getUserList("", "", "BODY2","Y"); //영업담당자 리스트
	int user_size = users.size();
	
	String reg_dt = Util.getDate();
	

	String comment_end_dt = p_db.getPropResCommentEndDt(p_bean.getReg_dt());
	

	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	int size = 0;
	
	String content_code = "PROP_BBS";
	String content_seq  = s_prop_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	String file_type2 = "";
	String seq2 = "";
	String file_name2 = "";
	
	String file_type3 = "";
	String seq3 = "";
	String file_name3 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq+1).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}else if((content_seq+2).equals(aht.get("CONTENT_SEQ"))){
			file_name2 = String.valueOf(aht.get("FILE_NAME"));
			file_type2 = String.valueOf(aht.get("FILE_TYPE"));
			seq2 = String.valueOf(aht.get("SEQ"));
			
		}else if((content_seq+3).equals(aht.get("CONTENT_SEQ"))){
			file_name3 = String.valueOf(aht.get("FILE_NAME"));
			file_type3 = String.valueOf(aht.get("FILE_TYPE"));
			seq3 = String.valueOf(aht.get("SEQ"));
		}
	}
	
	
		//2016-06-03 Text Editor 추가 -- ks.cho
	String content1 = p_bean.getContent1();
	if(!content1.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
		content1 = content1.replaceAll("\r\n","<br/>");
	}
	
	String content2 = p_bean.getContent2();
	if(!content2.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
		content2 = content2.replaceAll("\r\n","<br/>");
	}
	
	String content3 = p_bean.getContent3();
	if(!content3.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
		content3 = content3.replaceAll("\r\n","<br/>");
	}
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='../../include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
	var popObj = null;
<!--
//의견달기
function RegComment(idx){
	var SUBWIN="./prop_comment_i.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&mode="+idx;
	window.open(SUBWIN, "CommentReg", "left=100, top=100, width=520, height=400, scrollbars=no");
}

//의견달기
function RegReComment(prop_id, seq, re_seq){
	var SUBWIN="./prop_re_comment_i.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&seq="+seq+"&re_seq="+re_seq;
	window.open(SUBWIN, "ReCommentReg", "left=100, top=100, width=620, height=600, scrollbars=no");
}

//수정하기
function UpDisp(idx){
	var fm = document.form1;
	
	if(idx == 1) {
      fm.mode.value= '1';
		fm.target="d_content";
		fm.action="prop_u.jsp";		
		fm.submit();

	}	
	
	if(idx == 2) {
	var SUBWIN="./prop_u.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&mode="+idx+"&idx="+fm.idx.value;
	var height = 500;

	window.open(SUBWIN, "AncUp", "left=100, top=100, width=900, height="+height+", scrollbars=yes");
	}
	
		
}

//목록
function go_to_list()
{
	var fm = document.form1;
	fm.action = "./prop_s_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";
	fm.target = 'd_content';
	fm.submit();
}	

function view_comment(prop_id, seq, re_seq)
{
		window.open("prop_comment_u.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id="+prop_id+"&seq="+seq+"&re_seq="+re_seq, "MEMO", "left=100, top=100, width=750, height=550");
}

function view_c_eval(prop_id, seq, re_seq)
{
		var auth_rw = document.form1.auth_rw.value;		
		var user_id = document.form1.user_id.value;		
		window.open("c_eval_frame_s.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&user_id="+user_id+"&prop_id="+prop_id+"&seq="+seq+"&re_seq="+re_seq, "MEMO", "left=100, top=100, width=420, height=400");
}

function RegEvalAmt(prop_id){
	var user_id = document.form1.user_id.value;		
		
	var SUBWIN="./t_eval_frame_s.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&user_id="+user_id+"&prop_id="+prop_id;
	window.open(SUBWIN, "CommentReg", "left=100, top=100, width=520, height=400, scrollbars=no");
}

function RegCval(prop_id){
	var fm = document.form1;
	fm.action = "./prop_c_eval_i.jsp";
	fm.target = "i_no";
	fm.submit();
}


//스캔등록
function scan_reg(idx){
		window.open("prop_reg_scan.jsp?idx="+idx+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&prop_id=<%=prop_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLp_db="javascript:self.focus()">

<form name="form1" method="post">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='asc'	 	value='<%=asc%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>      
  <input type="hidden" name="prop_id" 	value="<%=prop_id%>">
  <input type="hidden" name="prize" 	value="<%=prize%>">
  <input type="hidden" name="mode" 		value="<%=mode%>">
  <input type="hidden" name="idx" value="<%=idx%>">	
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > <span class=style5>제안함</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<%if(!mode.equals("pop_view")){ %>
	<tr>
	  	<td align='right'>
			<a href="javascript:go_to_list()"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a>
	  	</td>
	</tr>
	<%} %>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	  	<td class="line">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>			
			  	<tr>
				  	<td width="5%" class="title">연번</td>
					<td width="11%" align=center>&nbsp;<%=idx%></td>
					<td width="9%" class="title">작성자</td>
					<td width="20%" align=center>&nbsp;
					<% if (  p_bean.getOpen_yn().equals("Y") || user_id.equals("000063")  ) { %><%=p_bean.getUser_nm()%>
					<% } else {  %>
					비공개 
					<% } %></td>
					<td width="9%" class="title">작성일</td>
					<td width="20%" align=center>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getReg_dt())%></td>
					<td width="9%" class="title">공개범위</td>
					<td width="20%" align=center>&nbsp;
					<% if (  p_bean.getPublic_yn().equals("Y")  ) { %> 
					외부(협력업체/에이전트)포함 공개
					<% } else {%>당사 <%} %></td>
			  	</tr>
			</table>
	  	</td>
	</tr>
	<tr>
		<td></td>
	</tr>
	
	<tr>	  
	  	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>제안내용</span></td>    
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>	  
	  	<td class=line>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr>
		          <td colspan="2" class="title">&nbsp;<br><%if(p_bean.getUse_yn().equals("Y") ||  p_bean.getUse_yn().equals("M")){ %><img src=/images/mservice_icon.gif align=absmiddle><% } %>
		          <%=p_bean.getTitle()%><br>&nbsp;</td>
		        </tr>		       	            
		        <tr>
		          <td width=9% class="title">문제점</td>
		          <td align="center" style="height:150" valign="top">
		          <table border="0" cellspacing="0" cellpadding="10" width=100%>
		              <tr>
		                <td style="padding:10px;"><%=content1%></td>
		              </tr>
		          </table></td>
		        </tr>
		        <tr>
		          <td class="title">개선안</td>
		          <td align="center" style="height:100" valign="top">
		          	<table border="0" cellspacing="0" cellpadding="10" width=100%>
		              <tr>
		                <td style="padding:10px;"><%=content2%></td>
		              </tr>
		          </table></td>
		        </tr>
		        <tr>
		          <td class="title">기대효과</td>
		          <td align="center" style="height:100" valign="top">
				    <table border="0" cellspacing="0" cellpadding="10" width=100%>
		              <tr>
		                <td style="padding:10px;"><%=content3%></td>
		              </tr>
		            </table>
				  </td>
		        </tr>
		        <tr>
					<td class="title">첨부파일1</td>
					<td >&nbsp; 
					<%if(!file_name1.equals("")){%>
						<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
							<a href="javascript:openPopF('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=file_name1%></a>
						<%}else{%>
							<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
						<%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					<%}else{%>
						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					<%}%>
					</td>	
				
				  </tr>
				  <tr>
					<td class="title">첨부파일2</td>
					<td >&nbsp; 
					<%if(!file_name2.equals("")){%>
						<%if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
							<a href="javascript:openPopF('<%=file_type2%>','<%=seq2%>');" title='보기' ><%=file_name2%></a>
						<%}else{%>
							<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
						<%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					<%}else{%>
						<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					<%}%>
					</td>
				  </tr>
				  <tr>
					<td class="title">첨부파일3</td>
				    <td >&nbsp; 
					<%if(!file_name3.equals("")){%>
						<%if(file_type3.equals("image/jpeg")||file_type3.equals("image/pjpeg")||file_type3.equals("application/pdf")){%>
							<a href="javascript:openPopF('<%=file_type3%>','<%=seq3%>');" title='보기' ><%=file_name3%></a>
						<%}else{%>
							<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq3%>" target='_blank'><%=file_name3%></a>
						<%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq3%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					<%}else{%>
						<a href="javascript:scan_reg('3')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
					<%}%>
					</td>
				</tr>

	      		</table>
	      	</td>    
		</tr>
		
	<%if(!mode.equals("pop_view")){ %>		
		<tr>
			<td>
				<table width=100% border=0 cellspacing=0 cellpadding=0>
					<tr>
						<td>
							<%if(!comment_end_dt.equals("")){%>
							※ 댓글등록기한 : <%=AddUtil.ChangeDate2(comment_end_dt)%>				
							<%}else{%>
							※ 댓글은 원글이 작성된 당월에만 입력할 수 있습니다. 
							<%}%>
						</td>
						<td align='right'>
						    <%if(p_bean.getExp_dt().equals("")){%>
							<%	if(user_id.equals(p_bean.getReg_id()) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
							<a href="javascript:UpDisp(1)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>
							<%	}%>
							<%}else{%>&nbsp;<%}%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	<tr>
		<td ></td>
	</tr>
	
	<%if(vt_size > 1){%>
	<tr>
		<td class=line>
			<table width=100% border=0 cellspacing=1 cellpadding=0>	
			<%if(!String.valueOf(next_ht.get("PROP_ID")).equals("") && !String.valueOf(next_ht.get("PROP_ID")).equals("null")){%>
			<tr>	  
				<td align="left" width=9% class=title>다음글 <img src=/acar/images/center/arrow_ja_n.gif align=absmiddle></td>
				<td>&nbsp;<a href="prop_c.jsp<%=valus%>&prop_id=<%=next_ht.get("PROP_ID")%>&idx=<%=next_ht.get("IDX")%>" onMouseOver="window.status=''; return true"><%=next_ht.get("TITLE")%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(next_ht.get("REG_DT")))%>&nbsp;[제안자 : <%if(!next_ht.get("OPEN_YN").equals("Y")){%>비공개<%}else{%><%=String.valueOf(next_ht.get("USER_NM"))%><%}%>]</a></td>
			</tr>
			<%}%>
			<%if(!String.valueOf(back_ht.get("PROP_ID")).equals("") && !String.valueOf(back_ht.get("PROP_ID")).equals("null")){%>	
			<tr>	  	
				<td align="left"  class=title><img src=/acar/images/center/arrow_ja_b.gif align=absmiddle> 이전글</td>
				<td>&nbsp;<a href="prop_c.jsp<%=valus%>&prop_id=<%=back_ht.get("PROP_ID")%>&idx=<%=back_ht.get("IDX")%>" onMouseOver="window.status=''; return true"><%=back_ht.get("TITLE")%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(back_ht.get("REG_DT")))%>&nbsp;[제안자 : <%if(!back_ht.get("OPEN_YN").equals("Y")){%>비공개<%}else{%><%=String.valueOf(back_ht.get("USER_NM"))%><%}%>]</a></td>
			</tr>
			<%}%>
			</table>
		</td>
	</tr>
	<%}%>
	<%}%>
	
			
	<tr>	  
		<td></td>    
	</tr>
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>제안검토 (관련부서)</span></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>	
	<tr>	  
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td class="title" width=7%>연번</td>
          <td class="title" width="57%">내용</td>
          <td class="title" width="7%">등록자</td>
          <td class="title" width="9%">등록일자</td>
          <td class="title" width="5%">찬/반</td>
          <td class="title" width="15%">평가</td>
        </tr>
		<%	for(int i=0; i<pc_r.length; i++){
	        	pc_bean = pc_r[i];
				String cont = AddUtil.replace(pc_bean.getContent(),"\\","&#92;&#92;");
				cont = AddUtil.replace(cont,"\"","&#34;");
				cont = Util.htmlBR(cont);
				if(pc_bean.getCom_st().equals("2")){
					count2++;
					 if(pc_bean.getYn()==0){ 
				  		cnt1++;		
				  	}else if(pc_bean.getYn()==1){ 
				  		cnt2++;			  	
				  	}else if(pc_bean.getYn()==2){ 
				  		cnt3++;			  		
				  	}
				%>		
        <tr>
         <% if ( user_id.equals("000029") || user_id.equals("000063") || user_id.equals("000237") ) { %>
          <%      if ( pc_bean.getCnt1() == 0 &&  pc_bean.getCnt2() == 0  && pc_bean.getCnt3() == 0 && pc_bean.getCnt4() == 0 && pc_bean.getCnt5() == 0 ) { %>
          <input type="hidden" name="seq" 	value="<%=pc_bean.getSeq()%>">
          <input type="hidden" name="re_seq" 	value="<%=pc_bean.getRe_seq()%>">
                  <%      } %>
          <%  }  %>   
          <td align="center">
          <% if ( user_id.equals("000029") || user_id.equals("000063") || user_id.equals("000237") ) { %>          
           <a href="javascript:view_c_eval('<%=pc_bean.getProp_id()%>','<%=pc_bean.getSeq()%>',<%=pc_bean.getRe_seq()%>)" onMouseOver="window.status=''; return true" >
          <%} %>
          <%=count2%>
          <% if ( user_id.equals("000029") || user_id.equals("000063") || user_id.equals("000237") ) { %>          
           </a>
          <%}%>              
          </td>          
          <td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%=cont%></td></tr></table></td>
          <td align="center">
		  <%if(user_id.equals(pc_bean.getReg_id()) && p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>
		  <a href="javascript:view_comment('<%=pc_bean.getProp_id()%>','<%=pc_bean.getSeq()%>','0')" onMouseOver="window.status=''; return true" ><%=pc_bean.getUser_nm()%></a>
		  <%}else{%>
		  
		  <% if (  pc_bean.getOpen_yn().equals("Y") || user_id.equals("000063")  ) { %><%=pc_bean.getUser_nm()%><% } else { %>비공개<% } %>
		
		  <%}%></td>
          <td align="center"><%=AddUtil.ChangeDate2(pc_bean.getReg_dt())%></td>
          <td align="center">
          <%if ( pc_bean.getYn()==0 ){ %>찬성 
          <%} else if ( pc_bean.getYn()==1 ){ %>반대 
          <%} else { %>기권 
          <% } %>
          </td>
          <td>&nbsp;
          <% if ( user_id.equals("000029") || user_id.equals("000063") || user_id.equals("000237") ) { %>
          <%      if ( pc_bean.getCnt1() == 0 &&  pc_bean.getCnt2() == 0  && pc_bean.getCnt3() == 0 && pc_bean.getCnt4() == 0 && pc_bean.getCnt5() == 0 ) { %>    
            <input type='text' name='e_amt' size='1' class='num' maxlength='1'  onBlur='javascript:this.value=parseDecimal(this.value);' >
          <%      } %>
          <%  }  %>
                      
            <%if (pc_bean.getCnt1() == 1) {%>
		        &nbsp;대표
		    <%} %>
            <%if (pc_bean.getCnt2() == 1) {%>
		        &nbsp;총무팀장
		    <%} %>
            <%if (pc_bean.getCnt3() == 1) {%>
		        &nbsp;영업팀장
		    <%} %>
            <%if (pc_bean.getCnt4() == 1) {%>
		        &nbsp;관리팀장
		    <%} %>
		    <%if (pc_bean.getCnt5() == 1) {%>
		         &nbsp;IT팀장
		    <%} %>
		  </td>
        </tr>
		<%		}
			}%>
      </table></td>    
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	
	<tr>	  
	  <td align="right">	  
	   <%if(p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>
<%if(AddUtil.parseInt(p_bean.getDay7()) > AddUtil.parseInt(AddUtil.ChangeString(reg_dt)) ){%>	   
	<!--	<a href="javascript:RegComment(2)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  aligh="absmiddle" border="0"></a> -->
<%}%>		
	 	<%}else{%>&nbsp;<%}%>	 
	  </td>    
	</tr>	
		
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>의견수렴 (직원)</span></td>    
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<%if(pc_r.length >0){%>	
	<tr>	  
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td class="title" width="7%">연번</td>
          <td class="title" width="57%">내용</td>
          <td class="title" width="7%">등록자</td>
          <td class="title" width="9%">등록일자</td>
          <td class="title" width="5%">찬/반</td>
          <td class="title" width="15%">평가</td>
        </tr>
		<%	for(int i=0; i<pc_r.length; i++){
	        	pc_bean = pc_r[i];
				String cont = AddUtil.replace(pc_bean.getContent(),"\\","&#92;&#92;");
				cont = AddUtil.replace(cont,"\"","&#34;");
				cont = Util.htmlBR(cont);
				if(pc_bean.getCom_st().equals("1")){
					count1++;
				  	if(pc_bean.getYn()==0){ 
				  		cnt1++;		
				  	}else if(pc_bean.getYn()==1){ 
				  		cnt2++;			  	
				  	}else if(pc_bean.getYn()==2){ 
				  		cnt3++;			  		
				  	}
				  	
		  	
		  	%>
		  	
        <tr>
          <% if (  user_id.equals("000029") || user_id.equals("000063")   || user_id.equals("000237") ) { %>
          <%      if ( pc_bean.getCnt1() == 0 &&  pc_bean.getCnt2() == 0  && pc_bean.getCnt3() == 0 && pc_bean.getCnt4() == 0 ) { %>    
             <input type="hidden" name="seq" 	value="<%=pc_bean.getSeq()%>">
             <input type="hidden" name="re_seq" value="<%=pc_bean.getRe_seq()%>">
          <%      } %>
          <%  }  %>
          <!-- 연번 -->   
          <td align="center" >
           <% if (  user_id.equals("000029") || user_id.equals("000063")   || user_id.equals("000237") ) { %>          
           <a href="javascript:view_c_eval('<%=pc_bean.getProp_id()%>','<%=pc_bean.getSeq()%>','<%=pc_bean.getRe_seq()%>')" onMouseOver="window.status=''; return true" >
          <%} %>
          <%=count1%>
          <% if ( user_id.equals("000029") || user_id.equals("000063")  || user_id.equals("000237") ) { %>          
           </a>
          <%}%>         
          </td>
          <!-- 내용 -->
          <td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%=cont%>
            <%if(p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>	
			<%		if(AddUtil.parseInt(p_bean.getDay7()) >= AddUtil.parseInt(AddUtil.ChangeString(reg_dt)) ){%>
			<a href="javascript:RegReComment('<%=pc_bean.getProp_id()%>','<%=pc_bean.getSeq()%>','<%=pc_bean.getRe_seq()%>')" onMouseOver="window.status=''; return true">
			                    <span style="font-size:15px; background-color:rgba(0, 51, 255, 0.81);border-radius:2px; color:white;">
							  		<span class="blink" style="font-size:12px;vertical-align:top;  ">&nbsp;댓글&nbsp;</span><!-- font-weight: bold; -->
							  	</span> 
			</a>				  	
			<%		} %>
			<%} %>	
          </td></tr>
          </table>                  
          </td>
          <td align="center">
		  <%if(user_id.equals(pc_bean.getReg_id()) && p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>
		  <a href="javascript:view_comment('<%=pc_bean.getProp_id()%>','<%=pc_bean.getSeq()%>','0')" onMouseOver="window.status=''; return true" ><%=pc_bean.getUser_nm()%></a>
		  <%}else{%>
		  <% if (  pc_bean.getOpen_yn().equals("Y") || user_id.equals("000063")  ) { %><%=pc_bean.getUser_nm()%><% } else { %>비공개<% } %>
		  <%}%>
		  </td>
          <td align="center"><%=AddUtil.ChangeDate2(pc_bean.getReg_dt())%></td>
          <td align="center">
          <%if ( pc_bean.getYn()==0 ){ %>찬성 
          <%} else if ( pc_bean.getYn()==1 ){ %>반대 
          <%} else { %>기권 
          <% } %>
          </td>
          <td>&nbsp;
          <% if ( user_id.equals("000029") || user_id.equals("000063")  || user_id.equals("000237") ) { %>
          <%      if ( pc_bean.getCnt1() == 0 &&  pc_bean.getCnt2() == 0  && pc_bean.getCnt3() == 0 && pc_bean.getCnt4() == 0  && pc_bean.getCnt5() == 0 ) { %>    
            <input type='text' name='e_amt' size='1' class='num' maxlength='1'  onBlur='javascript:this.value=parseDecimal(this.value);' >
          <%      } %>
          <%  }  %>
          
          <%if (pc_bean.getCnt1() == 1) {%>
		        &nbsp;대표
		    <%} %>
            <%if (pc_bean.getCnt2() == 1) {%>
		        &nbsp;총무팀장
		    <%} %>
            <%if (pc_bean.getCnt3() == 1) {%>
		        &nbsp;영업팀장
		    <%} %>
            <%if (pc_bean.getCnt4() == 1) {%>
		        &nbsp;관리팀장
		    <%} %>
	  		<%if (pc_bean.getCnt5() == 1) {%>
		        &nbsp;IT팀장
		    <%} %>	    
		  </td>
        </tr>
        
        
        <%
        	//댓글리스트
			PropCommentBean pc_r_re [] = p_db.getPropCommentAllList(pc_bean.getProp_id(), pc_bean.getSeq());
          
        %>
        <!-- 댓글 -->
        <%	if(pc_r_re.length >1){%>
          <% 		for(int k=1; k<pc_r_re.length; k++){
        	  			PropCommentBean pc_bean2 = pc_r_re[k];
        	  			String cont2 = AddUtil.replace(pc_bean2.getContent(),"\\","&#92;&#92;");
        				cont2 = AddUtil.replace(cont2,"\"","&#34;");
        				cont2 = Util.htmlBR(cont2);
        				if(pc_bean2.getYn()==0){ 
    				  		cnt1++;		
    				  	}else if(pc_bean2.getYn()==1){ 
    				  		cnt2++;			  	
    				  	}else if(pc_bean2.getYn()==2){ 
    				  		cnt3++;			  		
    				  	}
          %>
        <tr>
             <input type="hidden" name="seq" 	value="<%=pc_bean2.getSeq()%>">
             <input type="hidden" name="re_seq" value="<%=pc_bean2.getRe_seq()%>">
          <td align="center" >
          <% if (  user_id.equals("000029") || user_id.equals("000063")  || user_id.equals("000237") ) { %>          
           <a href="javascript:view_c_eval('<%=pc_bean2.getProp_id()%>','<%=pc_bean2.getSeq()%>','<%=pc_bean2.getRe_seq()%>')" onMouseOver="window.status=''; return true" >
          <%} %>
          <%=count1%>-<%=pc_bean2.getRe_seq()%>
          <% if ( user_id.equals("000029") || user_id.equals("000063")   || user_id.equals("000237") ) { %>          
           </a>
          <%}%>     
          </td>   
          <!-- 내용 -->
          <td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><font color=blue>[댓글]</font> <%=cont2%></td></tr></table></td>
          <td align="center">
		  <%if(user_id.equals(pc_bean2.getReg_id()) && p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>
		  <a href="javascript:view_comment('<%=pc_bean2.getProp_id()%>','<%=pc_bean2.getSeq()%>','<%=pc_bean2.getRe_seq()%>')" onMouseOver="window.status=''; return true" ><%=pc_bean2.getUser_nm()%></a>
		  <%}else{%>
		  <% if (  pc_bean2.getOpen_yn().equals("Y") || user_id.equals("000063")  ) { %><%=pc_bean2.getUser_nm()%><% } else { %>비공개<% } %>
		  <%}%>
		  </td>
          <td align="center"><%=AddUtil.ChangeDate2(pc_bean2.getReg_dt())%></td>
          <td align="center">
          <%if ( pc_bean2.getYn()==0 ){ %>찬성 
          <%} else if ( pc_bean2.getYn()==1 ){ %>반대 
          <%} else { %>기권 
          <% } %>
          </td>
          <td>&nbsp;
          <% if ( user_id.equals("000029") || user_id.equals("000063")   || user_id.equals("000237") ) { %>
          <%      if ( pc_bean2.getCnt1() == 0 &&  pc_bean2.getCnt2() == 0  && pc_bean2.getCnt3() == 0 && pc_bean2.getCnt4() == 0  && pc_bean2.getCnt5() == 0 ) { %>    
            <input type='text' name='e_amt' size='1' class='num' maxlength='1'  onBlur='javascript:this.value=parseDecimal(this.value);' >
          <%      } %>
          <%  }  %>
          
          <%if (pc_bean2.getCnt1() == 1) {%>
		        &nbsp;대표
		    <%} %>
            <%if (pc_bean2.getCnt2() == 1) {%>
		        &nbsp;총무팀장
		    <%} %>
            <%if (pc_bean2.getCnt3() == 1) {%>
		        &nbsp;영업팀장
		    <%} %>
            <%if (pc_bean2.getCnt4() == 1) {%>
		        &nbsp;관리팀장
		    <%} %>
	  		<%if (pc_bean2.getCnt5() == 1) {%>
		        &nbsp;IT팀장
		    <%} %>	    
		  </td>
        </tr>
        <%		}
        }%>          
        
        
		<%	}}	%>	
      </table></td>   
       
	<tr>	  
		<td align="right">
		&nbsp;
		<% if (  user_id.equals("000029") || user_id.equals("000063")  || user_id.equals("000237") ) { %>
		<a href="javascript:RegCval('<%=prop_id%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_pyg.gif"  aligh="absmiddle" border="0"></a>
		<% } else { %>
		&nbsp;
		<% } %>
		</td>    
	</tr>
	
	<%} %>
	
	<%if(!mode.equals("pop_view")){ %>	
	
	<tr>	  
		<td></td>    
	</tr>

	<tr>
		<% tot2=user_size-cnt1-cnt2-cnt3;%>
		<td class=line>	  
	  		<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
				  <td width=7% class=title><div align="center"><strong>총계</strong></div></td>
				  <td class=title><div align="center"><strong>찬성 : <%=cnt1%> 건 </strong></div></td>
				  <td class=title><div align="center"><strong>반대 : <%=cnt2%> 건 </strong></div></td>
				  <td class=title><div align="center"><strong>기권 : <%=cnt3%> 건 </strong></div></td>
			
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>	  
	  <td align="right">
	    <%if(p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>	
<%if(AddUtil.parseInt(p_bean.getDay7()) >= AddUtil.parseInt(AddUtil.ChangeString(reg_dt)) ){%>		
		<a href="javascript:RegComment(1)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  aligh="absmiddle" border="0"></a>
<%}%>	
		<%}else{%>&nbsp;<%}%>
	  </td>    
	</tr>
 <% if ( user_id.equals("000029") || user_id.equals("000063") || user_id.equals("000237")) { %>          
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>제안평가</span>&nbsp; 

	  </td>
	</tr>	
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td><%if (p_bean.getCnt1() == 1) {%>
		        &nbsp;대표
		    <%} %>
            <%if (p_bean.getCnt2() == 1) {%>
		        &nbsp;총무
		    <%} %>
            <%if (p_bean.getCnt3() == 1) {%>
		        &nbsp;영업
		    <%} %>
            <%if (p_bean.getCnt4() == 1) {%>
		        &nbsp;고객지원
		    <%} %>
	  		<%if (p_bean.getCnt5() == 1) {%>
		        &nbsp;I T
		    <%} %>	    
		</td>	 
	</tr>
	<tr>	  
	   <td align='right'><%if (!p_bean.getEval_magam().equals("Y")) {%><a href="javascript:RegEvalAmt('<%=prop_id%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  aligh="absmiddle" border="0"></a><% } %></td>    
	</tr>

<% } %>	

<%} %>

	<tr>	  
	  <td></td>    
	</tr>				
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>결과</span></td>    
	</tr>	
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	  <td class="line">
		<table border="0" cellspacing="1" cellpadding="0" width=100%>	
		  <tr>
		 	<td width="9%" class="title">채택여부</td>
			<td width="41%" >&nbsp;
			  <%if(p_bean.getUse_yn().equals("Y")){%>채택
			  <%} else if(p_bean.getUse_yn().equals("M")){%>수정채택
			  <%} else if(p_bean.getUse_yn().equals("O")){%>업무시정채택
			   <%} else if(p_bean.getUse_yn().equals("I")){%>정보제공
			  <%} else if(p_bean.getUse_yn().equals("N")){%>불채택 <% } %>
			</td>
			<td width="9%" class="title">처리기한</td>
			<td width="41%">&nbsp;<%=AddUtil.ChangeDate2(p_bean.getAct_dt())%></td>				
		  </tr>
		  <tr>
		    <td class="title">상태</td>
		    <td><%if(p_bean.getProp_step().equals("1")){%>
		        &nbsp;수렴중
		        <%}%>
                <%if(p_bean.getProp_step().equals("2")){%>
                &nbsp;심사중
                <%}%>
                <%if(p_bean.getProp_step().equals("3")){%>
                &nbsp;재심중
                <%}%>
                <%if(p_bean.getProp_step().equals("5")){%>
                &nbsp;보류중
                <%}%>
                <%if(p_bean.getProp_step().equals("6")){%>
                &nbsp;처리중
                <%}%>   
                <%if(p_bean.getProp_step().equals("9")){%>
                &nbsp;이관
                <%}%>                 
                <%if(p_bean.getProp_step().equals("7")){%>
                &nbsp;완료
                <%}%></td>
              <td class="title">심사일자</td>
		      <td>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getEval_dt())%></td>        
          </tr>      
          <tr>  
            <td class="title">완료일자</td>
		    <td>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getExp_dt())%></td>
		    <td class="title">포상<br>(점수/금액)</td>
			<td >&nbsp;<%=Util.parseDecimal(p_bean.getEval())%>&nbsp;/
			&nbsp;<%=Util.parseDecimal(p_bean.getPrize())%>&nbsp;</td>
	      </tr>
		  <tr>		  
		    <td class="title">지급금액</td>
			<td >&nbsp;<%=Util.parseDecimal(p_bean.getJigub_amt())%>&nbsp;
		    </td>
		    <td class="title">지급일자</td>
		    <td>&nbsp;<%=AddUtil.ChangeDate2(p_bean.getJigub_dt())%></td>		
	      </tr>
	
		<tr>
			<td class="title" >최종의견</td>			
			<td colspan="3"><%=HtmlUtil.htmlBR(p_bean.getContent())%></td>

		</tr>
		</table>
	  </td>
	</tr>	
	<%if(!mode.equals("pop_view")){ %>	
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	  <td align='right'>
	   
		<% if (  nm_db.getWorkAuthUser("제안평가자",user_id) || nm_db.getWorkAuthUser("제안처리자",user_id) ) { %>
		<a href="javascript:UpDisp(2)" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif"  aligh="absmiddle" border="0"></a>
		<%	}%>
	
	  </td>
	</tr>		
	<tr>	  
	  <td>&nbsp;</td>    
	</tr>
	<%	}%>
  </table>
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0"  noresize></iframe> 
</body>
</html>