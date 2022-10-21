<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width,height=device-height,user-scalable=yes,initial-scale=1.0;"> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#ffffff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}


/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%;  height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

.view_detail {width:100%; border-bottom:1px solid #DDDEE2; table-layout:fixed; font:12px;}
.view_detail th {padding:8px 0 5px 10px; width:25%; border-top:1px solid #DDDEE2; background:#F1F1F3; color:#3333cc; font-weight:bold; text-align:left; vertical-align:top;}
.view_detail td {padding:8px 5px 5px 10px; border-top:1px solid #DDDEE2; line-height:16px; vertical-align:top;}

.News_tit .date {padding-top:14px;font-size:18px;color:#888;}
.News_tit {padding:19px 21px 14px;border-bottom:1px #ddd solid;position:relative;}
.News_content {padding:10px 5px 15px;font-size:18px;color:#111;line-height:1px #ddd solid;}
.News_tit h3 {font-size:19px;color:#000;line-height:22px;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cooperation.*, acar.client.*, acar.im_email.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%

	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	cp_bean = cp_db.getCooperationBean(seq);
	
	
	Vector users = new Vector();
	
	if(cp_bean.getOut_id().equals("000004")){
		users = c_db.getUserListCooperation("", "", "DEPT3","Y"); // 총무팀장
	}else if(cp_bean.getOut_id().equals("000005")){
		users = c_db.getUserListCooperation("", "", "DEPT1","Y"); // 영업팀장
	}else if(cp_bean.getOut_id().equals("000026")){
		users = c_db.getUserListCooperation("", "", "DEPT2","Y"); // 관리부팀장
	}else if(cp_bean.getOut_id().equals("000053")){	
		users = c_db.getUserListCooperation("", "", "DEPT7","Y"); // 부산지점장
	}else if(cp_bean.getOut_id().equals("000052")){	
		users = c_db.getUserListCooperation("", "", "DEPT8","Y"); // 대전지점장
	}else if(cp_bean.getOut_id().equals("000054")){	
		users = c_db.getUserListCooperation("", "", "DEPT9","Y"); // 대구지점장
	}else if(cp_bean.getOut_id().equals("000020")){	
		users = c_db.getUserListCooperation("", "", "DEPT10","Y"); // 광주지점장
	}else{
		users = c_db.getUserList("", "", "EMP"); //전체직원 리스트
	}
	
	int user_size = users.size();
	
	//고객정보
	ClientBean client = al_db.getNewClient(cp_bean.getClient_id());
	
	//완료안내메일
	Vector im_vt =  ImEmailDb.getFmsInfoMailDocSendList(seq+"cooperation", cp_bean.getClient_id());
	int im_vt_size = im_vt.size();
%>
<body onLoad="javascript:self.focus()">
<form action='' name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_year' 	value='<%=s_year%>'>
  <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
  <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
  <input type='hidden' name='gubun1'	value='<%=gubun1%>'>    
  <input type='hidden' name='gubun2'	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3'	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4'	value='<%=gubun4%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='seq' 		value='<%=seq%>'>
  <input type='hidden' name='cmd' 		value=''>
  <input type="hidden" name="req_st" 	value="<%=cp_bean.getReq_st()%>">	

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">업무협조
			</div> 
        </div>
    </div>    
	<div id="contents">
	 <tbody>
			<div class="News_tit">
				<div>요청자구분 : 
					<%if(cp_bean.getReq_st().equals("1") || cp_bean.getReq_st().equals("")){%>직원<%}%>
					<%if(cp_bean.getReq_st().equals("2")){%>고객<%}%>
				</div>
				<div>요청일자 : 
			    	<%= AddUtil.ChangeDate2(cp_bean.getIn_dt()) %>
			    </div>
			    <div><%if(cp_bean.getReq_st().equals("2")){%>접수자<%}else{%>요청직원<%}%> : 
					<%=c_db.getNameById(cp_bean.getIn_id(),"USER")%>
			    </div>
			    <div>제목 :
			    	<%=cp_bean.getTitle()%>
			    </div>
				<div>내용 :
			    	<%=cp_bean.getContent()%>
			    </div>
			    <div>처리결과 : 
			    	<%=cp_bean.getOut_content()%>
			    </div>
					<%	if(cp_bean.getSub_id().equals("")){%>
				<tr>
					<td class='title'>협조부서</td>
					<td>&nbsp;
					<%	if(cp_bean.getOut_id().equals("")){%>
					<select name='out_id'>
						<option value="">관리자 선택 </option>
						<option value="000004" <%if(cp_bean.getOut_id().equals("000004"))%>selectec<%%>>총무팀장 </option>
						<option value="000005" <%if(cp_bean.getOut_id().equals("000005"))%>selectec<%%>>영업팀장 </option>
						<option value="000026" <%if(cp_bean.getOut_id().equals("000026"))%>selectec<%%>>고객지원부팀장 </option>
						<option value="000053" <%if(cp_bean.getOut_id().equals("000053"))%>selectec<%%>>부산지점장 </option>
						<option value="000052" <%if(cp_bean.getOut_id().equals("000052"))%>selectec<%%>>대전지점장 </option>
						<option value="000054" <%if(cp_bean.getOut_id().equals("000054"))%>selectec<%%>>대구지점장 </option>
						<option value="000020" <%if(cp_bean.getOut_id().equals("000020"))%>selectec<%%>>광주지점장 </option>
					<%	}else{%>	
					<%=c_db.getNameById(cp_bean.getOut_id(),"USER")%><input type='hidden' name='out_id' value='<%=cp_bean.getOut_id()%>'>
					<%	}%>
					</td>
				</tr>	
				<%}else{%>
				<input type='hidden' name='out_id' value='<%=cp_bean.getOut_id()%>'>
				<%}%>
			  <tr>
			    	<td class='title'>처리담당자</td>
					<td>&nbsp;					
					<%	if(cp_bean.getSub_id().equals("")){%>
						<select name='sub_id'>
							<option value="">담당자 선택</option>
							<%	if(user_size > 0){
									for (int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i);	%>
									<option value='<%=user.get("USER_ID")%>' <%if(cp_bean.getOut_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						</select>&nbsp;&nbsp;&nbsp;
						<a href='javascript:sub_input()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>					
					<%	}else{%>
					<%=c_db.getNameById(cp_bean.getSub_id(),"USER")%>
					<%		if(cp_bean.getOut_dt().equals("") && nm_db.getWorkAuthUser("전산팀",user_id)){%>
						<select name='sub_id'>
							<option value="">담당자 변경</option>
							<%	if(user_size > 0){
									for (int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i);	%>
									<option value='<%=user.get("USER_ID")%>' <%if(cp_bean.getOut_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						</select>&nbsp;&nbsp;&nbsp;
						<a href='javascript:sub_input()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>										
					<%		}else{%>
							<input type='hidden' name='sub_id' value='<%=cp_bean.getSub_id()%>'>
					<%		}%>
					<%	}%>
					</td>					
			    </tr>
				<%if(cp_bean.getReq_st().equals("2")){%>
				<tr>
			    	<td class='title'>고객</td>
			    	<td>
					  <table border=0 cellspacing=1 cellpadding=0 width=100%>
                        <tr>
	                      <td width=80>&nbsp;상호</td>
	                      	<td>:&nbsp;
							  <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='50' class='whitetext' readonly>
							  <%	if(cp_bean.getOut_dt().equals("")){%>
							  <!--
        			  			<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  			<span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>		
							  -->	
							  <%	}%>	
					  		  <input type='hidden' name='client_id' value='<%=cp_bean.getClient_id()%>'></td>
                        </tr>
                        <tr>
	                      	<td>&nbsp;담당자</td>
	                      	<td>:&nbsp;
							  <input type='text' name='agnt_nm' value='<%=cp_bean.getAgnt_nm()%>' size='20' class='text' style='IME-MODE: active'>
							  <%	if(cp_bean.getOut_dt().equals("") && cp_bean.getAgnt_nm().equals("")){%>							  							  
							  <span class="b"><a href='javascript:search_mgr(0)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
								(직접 입력 가능)							  
							  <%	}%>									
							  </td>
                        </tr>
                        <tr>
	                      	<td>&nbsp;이동전화</td>
	                      	<td>:&nbsp;
							  <input type='text' name='agnt_m_tel' value='<%=cp_bean.getAgnt_m_tel()%>' size='20' class='text' style='IME-MODE: active'></td>
                        </tr>
						<%	String email_1 = "";
							String email_2 = "";
							if(!cp_bean.getAgnt_email().equals("")){
								int mail_len = cp_bean.getAgnt_email().indexOf("@");
								if(mail_len > 0){
									email_1 = cp_bean.getAgnt_email().substring(0,mail_len);
									email_2 = cp_bean.getAgnt_email().substring(mail_len+1);
								}
							}
						%>										
                        <tr>
	                      	<td>&nbsp;이메일</td>
	                      	<td>:&nbsp;
							  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  			<select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>선택하세요</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.co.kr">yahoo.co.kr</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">직접 입력</option>
					  		    </select>
					  		  <input type='hidden' name='agnt_email' value='<%=cp_bean.getAgnt_email()%>'>
							  <!--<input type='text' name='agnt_email' value='<%=cp_bean.getAgnt_email()%>' size='50' class='text' style='IME-MODE: active'>-->							  
  							  <%if(!cp_bean.getOut_dt().equals("")){%>
							  &nbsp;&nbsp;<a href="javascript:Remail();"><img src="/acar/images/center/button_jbh.gif" align="absmiddle" border="0"></a>
							  <%}%>
							</td>
                        </tr>
                      </table>
			    	</td>
			    </tr>								
				<tr>
			    	<td class='title'>처리완료일</td>
			    	<td>&nbsp;
			    		<%	if(cp_bean.getOut_dt().equals("")){%>
						<%		if(!mode.equals("view")){%>
						<%			if(cp_bean.getSub_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
						<a href='javascript:ed_time_in()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>						
						※ 업무협조 처리결과내용 입력후 등록버튼을 클릭하면 등록됩니다.
						<%			}%>
						<%		}%>						
						<%	}else{%>
						<input type="text" name="out_dt" value="<%=cp_bean.getOut_dt()%>" class='text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>[처리완료]</font>
						<%	}%>
			    	</td>
			    </tr>				
				<%}else{%>
				<tr>
			    	<td class='title'>처리완료일</td>
			    	<td>&nbsp;
			    		<%	if(cp_bean.getOut_dt().equals("")){%>
						<%		if(!mode.equals("view")){%>
						<%			if(cp_bean.getSub_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
						<a href='javascript:ed_time_in()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>						
						※ 업무협조 처리결과내용 입력후 등록버튼을 클릭하면 등록됩니다.
						<%			}%>
						<%		}%>						
						<%	}else{%>
						<input type="text" name="out_dt" value="<%=cp_bean.getOut_dt()%>" class='text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>[처리완료]</font>
						<%	}%>
			    	</td>
			    </tr>
				
				<%}%>				
			</table>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;※ 요청자구분이 고객일때는 완료처리시 지정된 고객 담당자에게 요청완료안내메일이 발송됩니다.</td>
	</tr>	
	<tr>
		<td colspan="2">&nbsp;※ <b>이메일</b>에 처리결과가 보여지므로 <b>주민등록번호 등 보안</b>이 필요한 내용은 입력하지 말아야 합니다.</td>
	</tr>		
	<%if(cp_bean.getReq_st().equals("2")){%>
	<%		if(im_vt_size > 0){%>			
	<tr> 
        <td class=line2 colspan=2></td>
    </tr>		
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width="29%" class='title'>이메일주소</td>
                    <td width="23%" class='title'>발송일시</td>
                    <td width="23%" class='title'>열람일시</td>
                    <td width="10%" class='title'>수신여부</td>
                    <td width="10%" class='title'>발송상태</td>
                </tr>
              <%	for(int i = 0 ; i < im_vt_size ; i++){
    				      Hashtable ht = (Hashtable)im_vt.elementAt(i);%>		  
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("EMAIL")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
                    <td align='center'><%=ht.get("OCNT_NM")%></td>
                    <td align='center'><span title='<%=ht.get("NOTE")%>'><%=ht.get("ERRCODE_NM")%></span></td>
                </tr>
              <%	}%>				  
            </table>
        </td>
    </tr>	
	<%		}%>	
    <tr>
        <td class=h></td>
    </tr> 		
    <tr>
    	<td align='center'>		   
			<a href="http://fms1.amazoncar.co.kr/mailing/ask/re_ask.jsp?seq=<%=seq%>" target="_blank" onFocus="this.blur();" title='이메일확인'><img src=/acar/images/center/button_e_email.gif align=absmiddle border=0></a>
    	</td>
    </tr>	
	<%}%>
</form>
</table>
		  </div>			
	</tbody>
	</div>
</div>
</form>		
</body>
</html>
