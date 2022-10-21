<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.user_mng.*"%>
<%@ page import="acar.cooperation.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	Vector vt = cp_db.CooperationN4List(s_year, s_mon, "", s_kd, t_wd, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int count = 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script src='/include/common.js'></script>
<script>
//신청일자 - 등록
function addr_ask_stop_com(seq, in_id){
	var url = 'addr_ask_stop_com.jsp?seq='+seq+'&in_id='+in_id+'&gubun=out_dt';
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
	window.open(url, "popup", specs);
}	
//신청일자 - 취소
function addr_ask_stop_cancel(seq, in_id){
	var url = 'addr_ask_stop_com.jsp?seq='+seq+'&in_id='+in_id+'&gubun=cancel';
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
	window.open(url, "popup", specs);
}	

//신청일자 - 삭제
function addr_ask_stop_delete(seq, in_id){
	var con_test = confirm("삭제 처리 하시겠습니까?");
	if(con_test == true){
		var url = 'addr_ask_stop_com.jsp?seq='+seq+'&in_id='+in_id+'&gubun=delete';
		var specs = "left=10,top=10,width=572,height=166";
		specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
		window.open(url, "popup", specs);
	}
}
//협조부서 - 승인
function addr_ask_stop_appr(seq, in_id){
	var url = 'addr_ask_stop_com.jsp?seq='+seq+'&in_id='+in_id+'&gubun=sub_dt';
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
	window.open(url, "popup", specs);
}	

//협조부서 - 반려버튼
function addr_ask_stop_back_btn(k){
	document.getElementsByClassName("appr_area")[k].style.display="none";
	document.getElementsByClassName("back_area")[k].style.display="";
}
//협조부서 - 반려버튼 취소
function addr_ask_stop_back_btn_cancel(k){
	document.getElementsByClassName("appr_area")[k].style.display="";
	document.getElementsByClassName("back_area")[k].style.display="none";
	document.getElementsByName("out_content")[k].value="";
	
}
//협조부서 - 반려
function addr_ask_stop_back(seq, in_id, k){
	var out_content = document.getElementsByName("out_content")[k].value;
	if(!out_content){
		alert("사유를 반드시 입력해주세요");
		return false;
	}
	
	var con_test = confirm("반려처리하시겠습니까?");
	if(con_test == true){
		var url = 'addr_ask_stop_com.jsp?seq='+seq+'&in_id='+in_id+'&out_content='+out_content+'&gubun=back';
		var specs = "left=10,top=10,width=572,height=166";
		specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
		window.open(url, "popup", specs);
	} 
	
}
//협조부서 -승인 취소
function addr_ask_stop_sub_cancel(seq, in_id){
	var url = 'addr_ask_stop_com.jsp?seq='+seq+'&in_id='+in_id+'&gubun=sub_cancel';
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
	window.open(url, "popup", specs);
}	

//협조부서 - 반려취소
function addr_ask_stop_sub_cancel(seq, in_id){
	var url = 'addr_ask_stop_com.jsp?seq='+seq+'&in_id='+in_id+'&gubun=back_cancel';
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
	window.open(url, "popup", specs); 
	
}	

function onKeyDown(seq, cls_dt){
	if( cls_dt && ChangeDate(cls_dt)){
		regCls(seq, cls_dt);	
	}
	//삭제 기능 가능
	if(!cls_dt)regCls(seq, cls_dt);
}
function regCls(seq, cls_dt){
	var url = 'addr_ask_stop_com.jsp?seq='+seq+'&cls_dt='+cls_dt+'&gubun=cls_dt';
	var specs = "left=10,top=10,width=572,height=166";
	specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
	window.open(url, "popup", specs);
}
</script>
</head>

<body>
<form name='form1' action='' method="POST">

<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td width='3%' class='title'> 연번 </td>
					<td width='8%' class='title'> 요청일자 </td>
					<td width='6%' class='title'> 요청자 </td>
					<td width='37%' class='title'> 제목 </td>
					<td width='19%' class='title'> 협조부서 팀장 </td>
					<td width='19%' class='title' id="apldtText"> 신청일자 </td>
					<%if(!gubun2.equals("4")){%>
					<td width='4%' class='title'> 해지일자 </td>
					<%} %>
					<td width='4%' class='title'> 삭제 </td>
				</tr>
<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
				<input type="hidden" name="seq" value="<%=ht.get("SEQ")%>" />
				<tr>
					<td width='3%'  align='center'><%=(i+1)%></td>
					<td width='8%'  align='center'><%= AddUtil.ChangeDate2((String)ht.get("IN_DT")) %></td>
					<td width='6%'  align='center'><%=ht.get("USER_NM")%></td>
					<td width='37%'>&nbsp;<a href="javascript:parent.view_content('<%=String.valueOf(ht.get("TITLE")).substring(12,26)%>','<%=String.valueOf(ht.get("SEQ"))%>')" onMouseOver="window.status=''; return true"><%=ht.get("TITLE")%></a></td>
					<td width='19%'  align='center'>
						<table width=100% border=0 cellspacing=0 cellpadding=5>
							<tr>
								<td>
									<div style="width:100%">
									<%if(ht.get("SUB_DT").equals("")){%>
										<%if( nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals("000026") ){%> <!--고객지원팀장님 권한  -->
											<div class="appr_area" style="text-align:center;">
												<a href="javascript:addr_ask_stop_appr('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')"><img src='/acar/images/center/button_in_si.gif' border=0></a>
												<span style="margin-left:25px;"></span>
												<a href="javascript:addr_ask_stop_back_btn('<%=count%>')"><img src='/acar/images/center/button_in_cp.gif' border=0 ></a>
											</div>
											
											<div class="back_area" style="display:none;text-align:center;">
												<input type="text" name="out_content" value="" placeholder="사유를입력하세요">
												<a href="javascript:addr_ask_stop_back('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>','<%=count%>')"><img src='/acar/images/center/button_in_cp.gif' border=0 align="absmiddle" ></a>
												<br>
												<a href="javascript:addr_ask_stop_back_btn_cancel('<%=count%>')"><img src='/acar/images/center/button_in_cancel.gif' border=0 style="margin-top:5px;"></a>
											</div>
										<%}%>
										<%count++; %>
									<%}else{%>
									
										<%if(!ht.get("OUT_CONTENT").equals("발송") && !ht.get("OUT_CONTENT").equals("")){%>
											<div style="display:inline-block;width:80%;"><span title="<%=ht.get("OUT_CONTENT")%>"><%=Util.subData(String.valueOf(ht.get("OUT_CONTENT")), 24)%></span></div>
										<%}else{%>
											<div style="display:inline-block;width:80%;"><%=ht.get("SUB_DT")%></div>
										<%}%>
										
										<%if( nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals("000026") ){%> <!--고객지원팀장님 권한  -->
											<%if(ht.get("OUT_DT").equals("") && ht.get("OUT_CONTENT").equals("발송")){%>
												<div style="display:inline-block;width:15%;">
												<a href="javascript:addr_ask_stop_sub_cancel('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')" style="text-align:right;">
													<img src='/acar/images/center/button_in_cancel.gif' border=0>
												</a>
												</div>
											<%}%>
											<%if(!ht.get("OUT_CONTENT").equals("발송")){%>
												<div style="display:inline-block;width:15%;">
													<a href="javascript:addr_ask_stop_sub_cancel('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')" style="text-align:right;">
														<img src='/acar/images/center/button_in_cancel.gif' border=0 >
													</a>
												</div>
											<%}%>
										
										<%}%>
									<%}%>
									</div>
								</td>
							</tr>
						</table>
					</td>
					<td width='19%' align='center'>
						<table width=100% border=0 cellspacing=0 cellpadding=5>
							<tr>
								<td align=center>
									<%if(ht.get("OUT_DT").equals("") && !ht.get("SUB_DT").equals("")){%>
										<%if( nm_db.getWorkAuthUser("전산팀",user_id) ||  nm_db.getWorkAuthUser("채권관리팀",user_id)){%> <!--채권관리자 권한  -->

										<a href="javascript:addr_ask_stop_com('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')"><img src='/acar/images/center/button_in_reg.gif' border=0></a>
										
										<%}%>
									<%}else if(!ht.get("OUT_DT").equals("") && !ht.get("SUB_DT").equals("")){%>
										<%=ht.get("OUT_DT")%><span style="margin-left:25px;"></span>
										<%if( nm_db.getWorkAuthUser("전산팀",user_id) ||  nm_db.getWorkAuthUser("채권관리팀",user_id)){%> <!--채권관리자 권한  -->
										<a href="javascript:addr_ask_stop_cancel('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')"><img src='/acar/images/center/button_in_cancel.gif' border=0></a>
										
										<%}%>
									<%}%>
								</td>
							</tr>
						</table></td>
					<%if(!gubun2.equals("4")){%>
					<td width='4%' align='center'>
						
							<input type="text" name="cls_dt" maxlength="10" onkeypress="if(event.keyCode==13)javascript:onKeyDown('<%=ht.get("SEQ")%>',this.value)" style="text-align:center;" 
							value="<%= AddUtil.ChangeDate2((String)ht.get("CLS_DT"))%>">
					
					</td>
					<%} %>
					<td width='4%' align='center'><!-- 채권관리자 / 고객지원팀장 / 등록자 권한  -->
						<%if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || String.valueOf(ht.get("IN_ID")).equals(user_id) ){%>
						<a href="javascript:addr_ask_stop_delete('<%=ht.get("SEQ")%>','<%=ht.get("IN_ID")%>')"><img src='/acar/images/center/button_in_delete.gif' border=0 ></a>
						<%}%>
					</td>
				</tr>
			<%}
		}
	else
	{
%>
				<tr>
					<td colspan='8' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%
	}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>