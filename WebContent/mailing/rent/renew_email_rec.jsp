<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>


<%
	
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
		
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String mail_code	 	= request.getParameter("mail_code")==null?"":request.getParameter("mail_code");
	
	String answer1	 	= request.getParameter("answer1")==null?"":request.getParameter("answer1");
	String answer2	 	= request.getParameter("answer2")==null?"":request.getParameter("answer2");
	String answer3	 	= request.getParameter("answer3")==null?"":request.getParameter("answer3");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//연장대여정보
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		
	//연장담당자
	UsersBean bus_user_bean = umd.getUsersBean(ext_fee.getExt_agnt());
	
	//이메일첨부파일
	Vector vt =  ImEmailDb.getImDmailEncListF("5", rent_l_cd+""+rent_st, mail_code+"newcar_doc");
	int vt_size = vt.size();
	
	Hashtable ht1 = new Hashtable();
	Hashtable ht2 = new Hashtable();
	
	if(vt_size==0){
		vt =  ImEmailDb.getImDmailEncList("5", rent_l_cd+""+rent_st, mail_code+"newcar_doc");
		vt_size = vt.size();
	}
	
	for(int i = 0 ; i < vt_size ; i++){
		if(i==0) ht1 = (Hashtable)vt.elementAt(i);
		if(i==1) ht2 = (Hashtable)vt.elementAt(i);
	}	
	
			
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>연장계약 답변 결과</title>
<link href=http://fms1.amazoncar.co.kr/acar/main_car_hp/style.css rel=stylesheet type=text/css>
<style type=text/css>
<!--
.style1 {color: #2e4168; font-size:13px;font-weight: bold;font-family:nanumgothic;}
.style2 {color: #636262;font-size:13px;font-family:nanumgothic;}
.style10 {color: #88b228;font-size:13px;font-family:nanumgothic;}
.style11 {
	color: #a71a41;
	font-weight: bold;
	font-family:nanumgothic;
	font-size:13px;
}
.style3{color:#000000;font-size:13px;font-weight: bold;font-family:nanumgothic;}
.style6 {color: #385c9d; font-weight: bold;font-size:13px;font-family:nanumgothic;}
.style15{color:#000000;font-size:13px;font-family:nanumgothic;}
-->
</style>
<script>
<!--	
	function openPopP(type,content_code, seq){
			
		var isImage = type.indexOf("image/") != -1 ? true : false;
		var isPDF = type.indexOf("/pdf") != -1 ? true : false;
		var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
		if( isImage || isPDF ){
			if(type.indexOf("image/") != -1 ) {
				url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview_print_email.jsp';
			}
								
			url = url + "?CONTENT_CODE="+content_code+"&SEQ=" + seq;
			var popName = "view_file";
			var aTagObj = document.getElementById("link_view_a");
				
			if( aTagObj == null ){
				var aTag = document.createElement("a");
				aTag.setAttribute("href", url);
				aTag.setAttribute("target",popName);
				aTag.setAttribute("id","link_view_a");
				target = document.getElementsByTagName("body");
				target[0].appendChild(aTag);
				aTagObj = document.getElementById("link_view_a");
			}else{
				aTagObj.setAttribute("href", url);
			}
				
			var pop = window.open('', popName, "left=300, top=250, width=1000, height=1000, scrollbars=yes");
			
			aTagObj.click();
				
				
		}else{
			alert('보기를 할수없는 파일입니다.');
		} 	
	}				
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>            
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ask/images/img_bg.gif>
                <tr>
                    <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_img_end_1.gif height=260 align=center  valign=top>
                    	<table width=480 border=0 cellspacing=0 cellpadding=0>
                    		<tr>
                    			<td height=165></td>
                    		</tr>
                       		<tr>
	                            <td class=style2 height=40> &nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow.gif align=absmiddle> 발신자 : <span class=style10><b><%=client.getFirm_nm()%></b></span></td>
	                        </tr> 
	                        <tr>
	                            <td class=style2> &nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow.gif align=absmiddle> 수신자  : (주)아마존카 </span></td>
	                        </tr> 
	                    </table>
                    </td>
                </tr>
                <tr>
                	<td height=40></td>
                </tr>
				<tr>
					<td align=center>
						<table width=490 border=0 cellpadding=0 cellspacing=0>
							<tr>
								<td><span class=style3>아래 내용대로 연장계약을 진행하고자 합니다.</span></td>
							</tr>
							<tr>
								<td height=30></td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6>1. 첨부한 jpg파일의 연장계약서 내용을 충분히 잘 읽어보았습니까?</span></td>
							</tr>
							<tr>
								<td><span class=style15>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer1" value='Y' <%if(answer1.equals("Y")){%>checked<%}%> disabled> 예, 잘 읽어보았습니다  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type='radio' name="answer1" value='N' <%if(answer1.equals("N")){%>checked<%}%> disabled> 아니오 </span></td>
							</tr>
							<tr>
								<td height=30></td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6>2. 본 연장계약서 내용대로 연장계약을 진행할 의사가 있습니까?</span></td>
							</tr>
							<tr>
								<td><span class=style15>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer2" value='Y' <%if(answer2.equals("Y")){%>checked<%}%> disabled> 예, 진행할 의사가 있습니다  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer2" value='N' <%if(answer2.equals("N")){%>checked<%}%> disabled> 아니오 </span></td>
							</tr>
							<tr>
								<td height=30></td>
							</tr>
							<tr>
								<td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6>3. 지금 보내는 e-mail을 아마존카 영업담당자가 받으면 연장계약이 성립하는 것에<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;동의합니까?</span></td>
							</tr>
							<tr>
								<td><span class=style15>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer3" value='Y' <%if(answer3.equals("Y")){%>checked<%}%> disabled> 예, 동의합니다  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer3" value='N' <%if(answer3.equals("N")){%>checked<%}%> disabled> 아니오 </span></td>
							</tr>
									</table>
								</td>
							</tr>
							<tr>
						    	<td height=25></td>
						    </tr>
							<tr>
								<td align=center height=30><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_pop_img4.gif></td>
							</tr>
							<tr>
								<td align=center>
									<table width=480 border=0 cellspacing=0 cellpadding=0>
										<tr>
											<td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow_1.gif align=absmiddle> <span class=style3>계약서 : </span>
											
					<span class=style15><%if(String.valueOf(ht1.get("ATTACH_SEQ")).equals("")){%>
					<a href=<%=ht1.get("FILE_CONTENT")%> target=blank><%=ht1.get("FILEINFO")%></a>
					<%}else{%>
					<a href="javascript:openPopP('image/','<%=ht1.get("CONTENT_CODE")%>', '<%=ht1.get("ATTACH_SEQ")%>');" title='보기' ><%=ht1.get("FILEINFO")%><%=ht1.get("FILENAME")%></a>
					<%}%>
																											
											<br>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
											
					<%if(String.valueOf(ht2.get("ATTACH_SEQ")).equals("")){%>
					<a href=<%=ht2.get("FILE_CONTENT")%> target=blank><%=ht2.get("FILEINFO")%></a>
					<%}else{%>
					<a href="javascript:openPopP('image/','<%=ht2.get("CONTENT_CODE")%>' , '<%=ht2.get("ATTACH_SEQ")%>');" title='보기' ><%=ht2.get("FILEINFO")%><%=ht2.get("FILENAME")%></a>
					<%}%></span>
																						
											</td>
										</tr>
										<tr>
											<td height=5></td>
										</tr>
										<tr>
											<td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow_1.gif align=absmiddle> <span class=style3>영업담당 : <%=bus_user_bean.getUser_nm()%> <%=bus_user_bean.getUser_m_tel()%></span></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
						    	<td height=30></td>
						    </tr>
			                <tr>
			                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_img_2.gif></td>
			                </tr>
            			</table> 

				        </td>
				    </tr>
				    <tr>
				        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
				    </tr>
				    <tr>
				        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
				    </tr>
				    <tr>
				        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
				    </tr>
				    <tr>
				        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
				            <table width=700 border=0 cellspacing=0 cellpadding=0>
				                <tr>
				                    <td width=40>&nbsp;</td>
				                    <td width=82 align=center><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
				                    <td width=32>&nbsp;</td>
				                    <td width=1 bgcolor=dbdbdb></td>
				                    <td width=33>&nbsp;</td>
				                    <td width=512><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
				                </tr>
				                <map name=Map1>
				                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
				                </map>
				            </table>
				        </td>
				    </tr>
				    <tr>
				        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
				    </tr>
				    <tr>
				        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
				    </tr>
				  </table>
			</td>
		</tr>
</table>
</body>
</html>