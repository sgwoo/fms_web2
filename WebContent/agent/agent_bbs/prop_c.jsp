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
	
	Vector vt = p_db.getOffPropList(s_kd, t_wd, gubun1, st_dt, end_dt, "O", gubun3, gubun4, user_id);
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
	
	//등록기한이 공휴일이면 익일로 해야한다.
	if(p_bean.getDay7().equals("20110508")){
		p_bean.setDay7("20110510");
	}
	
	String comment_end_dt = p_db.getPropResCommentEndDt(p_bean.getReg_dt());
	
	if(comment_end_dt.equals("20120104") && AddUtil.parseInt(p_bean.getReg_dt()) < 20111216){
		comment_end_dt = "";
	}

	if(!comment_end_dt.equals("")){
		//댓글기한일 다음날부터는 제한한다.
		p_bean.setDay7(c_db.addDay(comment_end_dt, 1));					
	}
	
	String  theURL  =  "https://fms3.amazoncar.co.kr/data/prop/";	
	
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
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='../../include/common.js'></script>

<script language='javascript'>
	var popObj = null;
<!--
//의견달기
function RegComment(idx){
	var SUBWIN="./prop_comment_i.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&mode="+idx;
	window.open(SUBWIN, "CommentReg", "left=100, top=100, width=520, height=400, scrollbars=no");
}

//수정하기
function UpDisp(idx){
	var fm = document.form1;
	var SUBWIN="./prop_u.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&mode="+idx+"&idx="+fm.idx.value;
	var height = 400;
	if(idx == 1) height = 700;
	window.open(SUBWIN, "AncUp", "left=100, top=100, width=900, height="+height+", scrollbars=no");
}

//목록
function go_to_list()
{
	var fm = document.form1;
	fm.action = "./prop_s_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";
	fm.target = 'd_content';
	fm.submit();
}	

function view_comment(prop_id, seq)
{
		window.open("prop_comment_u.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id="+prop_id+"&seq="+seq, "MEMO", "left=100, top=100, width=720, height=500");
}

function view_c_eval(prop_id, seq)
{
		var auth_rw = document.form1.auth_rw.value;		
		var user_id = document.form1.user_id.value;		
		window.open("c_eval_frame_s.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&user_id="+user_id+"&prop_id="+prop_id+"&seq="+seq, "MEMO", "left=100, top=100, width=420, height=400");
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

		//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		
		theURL = "https://fms3.amazoncar.co.kr/data/prop/"+theURL;
		//popObj = window.open('',winName,features);
		popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		popObj.location = theURL
		popObj.focus();
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>      
  <input type="hidden" name="prop_id" 	value="<%=prop_id%>">
  <input type="hidden" name="prize" 	value="<%=prize%>">
  <input type="hidden" name="mode" 		value="">
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
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 공지사항 ><span class=style5>제안함</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	  	<td align='right'>
			<a href="javascript:go_to_list()"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a>
	  	</td>
	</tr>
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
					<% if (  p_bean.getOpen_yn().equals("Y")) { %><%=p_bean.getUser_nm()%>
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
		          <td align="center"><table border="0" cellspacing="0" cellpadding="10" width=100%>
		              <tr>
		                <td><%=HtmlUtil.htmlBR(p_bean.getContent1())%></td>
		              </tr>
		          </table></td>
		        </tr>
		        <tr>
		          <td class="title">개선안</td>
		          <td align="center">
		          	<table border="0" cellspacing="0" cellpadding="10" width=100%>
		              <tr>
		                <td><%=HtmlUtil.htmlBR(p_bean.getContent2())%></td>
		              </tr>
		          </table></td>
		        </tr>
		        <tr>
		          <td class="title">기대효과</td>
		          <td align="center">
				    <table border="0" cellspacing="0" cellpadding="10" width=100%>
		              <tr>
		                <td><%=HtmlUtil.htmlBR(p_bean.getContent3())%></td>
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
							<%	if(user_id.equals(p_bean.getReg_id())){%>
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
          
          <td align="center">
         
          <%=count2%>
          
          </td>          
          <td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%=cont%></td></tr></table></td>
          <td align="center">
		  <%if(user_id.equals(pc_bean.getReg_id()) && p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>
		  <a href="javascript:view_comment('<%=pc_bean.getProp_id()%>','<%=pc_bean.getSeq()%>')" onMouseOver="window.status=''; return true" ><%=pc_bean.getUser_nm()%></a>
		  <%}else{%>
		  
		  <% if (  pc_bean.getOpen_yn().equals("Y")) { %><%=pc_bean.getUser_nm()%><% } else { %>비공개<% } %>
		
		  <%}%></td>
          <td align="center"><%=AddUtil.ChangeDate2(pc_bean.getReg_dt())%></td>
          <td align="center">
          <%if ( pc_bean.getYn()==0 ){ %>찬성 
          <%} else if ( pc_bean.getYn()==1 ){ %>반대 
          <%} else { %>기권 
          <% } %>
          </td>
          <td>&nbsp;
          
                      
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
          
          <td align="center">
          
          <%=count1%>
          
          </td>
          <td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%=cont%>
          	<%if(p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>	
			<%		if(AddUtil.parseInt(p_bean.getDay7()) >= AddUtil.parseInt(AddUtil.ChangeString(reg_dt)) ){%>
			                    <span style="font-size:15px; background-color:rgba(0, 51, 255, 0.81);border-radius:2px; color:white;">
							  		<span class="blink" style="font-size:11px;vertical-align:top; font-weight: bold; ">&nbsp;댓글&nbsp;</span>
							  	</span> 
			<%		} %>
			<%} %>
          </td></tr>
          <!-- 댓글리스트 -->
          
          </table></td>
          <td align="center">
		  <%if(user_id.equals(pc_bean.getReg_id()) && p_bean.getExp_dt().equals("") && ( p_bean.getProp_step().equals("1") || p_bean.getProp_step().equals("")) ){%>
		  <a href="javascript:view_comment('<%=pc_bean.getProp_id()%>','<%=pc_bean.getSeq()%>')" onMouseOver="window.status=''; return true" ><%=pc_bean.getUser_nm()%></a>
		  <%}else{%>
		  <% if (  pc_bean.getOpen_yn().equals("Y") ) { %><%=pc_bean.getUser_nm()%><% } else { %>비공개<% } %>
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
		<%	}}	%>	
      </table></td>   
       
	<tr>	  
		<td align="right">
		&nbsp;		
		</td>    
	</tr>
	
	<%} %>
	
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
			<td width="9%" class="title" >최종의견</td>			
			<td colspan="3"><%=HtmlUtil.htmlBR(p_bean.getContent())%></td>

		</tr>
		</table>
	  </td>
	</tr>	
  </table>
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0"  noresize></iframe> 
</body>
</html>