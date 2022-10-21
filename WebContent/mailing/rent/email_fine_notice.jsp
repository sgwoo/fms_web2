<%@page import="com.sun.xml.internal.fastinfoset.Decoder"%>
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.net.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%
String gov_nm 		= request.getParameter("gov_nm")		==null?"":request.getParameter("gov_nm");
String file_type 	= request.getParameter("file_type")		==null?"":request.getParameter("file_type");
String file_size 		= request.getParameter("file_size")		==null?"":request.getParameter("file_size");
String seq 			= request.getParameter("seq")				==null?"":request.getParameter("seq");
String content_code = request.getParameter("content_code")				==null?"FINE":request.getParameter("content_code");
String title 			= request.getParameter("title")			==null?"":request.getParameter("title");
String gov_id 		= request.getParameter("gov_id")		==null?"":request.getParameter("gov_id");

String vio_pla 		= request.getParameter("vio_pla") 		== null ? "" : request.getParameter("vio_pla");
String vio_dt 			= request.getParameter("vio_dt") 			== null ? "" : request.getParameter("vio_dt");
String vio_st 			= request.getParameter("vio_st") 			== null ? "" : request.getParameter("vio_st");
String vio_cont 		= request.getParameter("vio_cont") 		== null ? "" : request.getParameter("vio_cont");

// String fine_st			= request.getParameter("fine_st") 			== null ? "" : request.getParameter("fine_st");
// String notice_dt 		= request.getParameter("notice_dt") 		== null ? "" : request.getParameter("notice_dt");
// String paid_no 		= request.getParameter("paid_no") 		== null ? "" : request.getParameter("paid_no");
// String obj_end_dt 	= request.getParameter("obj_end_dt") 	== null ? "" : request.getParameter("obj_end_dt");
// String doc_id 			= request.getParameter("doc_id") 			== null ? "" : request.getParameter("doc_id");
// String doc_dt	 		= request.getParameter("doc_dt") 			== null ? "" : request.getParameter("doc_dt");
// String print_dt 		= request.getParameter("print_dt") 		== null ? "" : request.getParameter("print_dt");
// String obj_dt1 		= request.getParameter("obj_dt1") 		== null ? "" : request.getParameter("obj_dt1");
// String obj_dt2 		= request.getParameter("obj_dt2") 		== null ? "" : request.getParameter("obj_dt2");
// String obj_dt3 		= request.getParameter("obj_dt3") 		== null ? "" : request.getParameter("obj_dt3");

if(!gov_nm.equals("")){	URLDecoder.decode(gov_nm, "EUC-KR");			}
if(!title.equals("")){			URLDecoder.decode(title, "EUC-KR");				}

if(!vio_pla.equals(""))	{		vio_pla = URLDecoder.decode(vio_pla, "EUC-KR");		}
if(!vio_cont.equals("")){		vio_cont = URLDecoder.decode(vio_cont, "EUC-KR");		}
// if(!doc_id.equals(""))	{		doc_id = URLDecoder.decode(doc_id, "EUC-KR");			}

CommonDataBase c_db = CommonDataBase.getInstance();

CommonEtcBean ce_bean = c_db.getCommonEtc("fine_notice_ment", "gubun", title, "", "", "", "", "", "");
if(!gov_id.equals("")){		
	FineGovBn = FineDocDb.getFineGov(gov_id);
}
	
%>

<html>
<head>
<title>아마존카 과태료 안내문</title>
<meta http-equiv="Content-Type" content="text/html"; charset="euc-kr">
<script language='javascript'>
<!--
	
//-->
</script>
<style type="text/css">
</style>
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
        <td height=20></td>
    </tr>
    
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>

    <tr>
        <td height=40 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=685 border=0 cellspacing=0>
                <tr>
                	<td align="center" style="padding-top:50px;padding-bottom:50px;background:linear-gradient(#ffe4b5, #ffe4b5 30%, #68d168);border-radius: 15px;">
                		<table width=585 border=0 cellspacing=0  style="border: 10px solid #ebc680; border-radius: 10px;background-color: white;">
                			<tr>
			                    <td style="padding-top:30px;padding-bottom:30px;font-size: 30px;font-family: Nanumgothic, AppleMyungjo;font-weight: bold; padding-left:30px;"><div>과태료 안내문</div></td>
			                </tr>
			                <tr>
			                	<td style="padding-bottom:20px;font-size: 14px;color: #369f36; font-family:Nanumgothic; font-weight:bold;padding-left:30px;">
			                		<%=gov_nm%> 님
			                	</td>
			                </tr>
			                <tr>
			                	<td style="font-size: 14px;font-family:Nanumgothic; font-weight:bold; padding-left:30px; padding-right:30px;">
			                		<div style="color: #c90909">항상 저희 (주)아마존카를 이용해 주셔서 감사드립니다.</div><br>
			                		<pre><%=ce_bean.getEtc_content()%></pre>
			                		<%-- <%if(!FineGovBn.getGov_nm().equals("")){%>
			                			<br><div align="right"><%=FineGovBn.getGov_nm() %></div>
			                		<%}%>	 --%>
			                	</td>
			                </tr>
			                <tr>
			                	<td align="right" style="font-size: 14px; font-family:Nanumgothic; font-weight:bold; padding-left:30px; padding-right:30px;"><img alt="" src="http://fms1.amazoncar.co.kr/acar/images/sign_1.png" style="margin-top: 30px;">  </td>
			                </tr>
			                <%-- <%if(!(fine_st.equals("") && notice_dt.equals("") && paid_no.equals("") && vio_pla.equals("") && vio_dt.equals("") && vio_st.equals("") && FineGovBn.getGov_nm().equals("") && obj_end_dt.equals("")) ){ %> --%>
			                <%if( !(vio_pla.equals("") && vio_dt.equals("") && vio_st.equals("") && FineGovBn.getGov_nm().equals("")) ){ %>
			                <tr>
			                	<td  style="font-size: 14px; font-family:Nanumgothic; font-weight:bold; padding-left:30px; padding-right:30px; ">
			                		<ul>
			                			<%-- <% if(!fine_st.equals("")){ %>
			                			<li>
			                				구분: <% if(fine_st.equals("1")){%> 과태료 <%} else if(fine_st.equals("2")){%> 범칙금 <%} else if(fine_st.equals("3")){%> 안내문<%} %>
			                			</li>
			                			<%} %>
			                			<% if(!notice_dt.equals("")){ %>
			                			<li style="padding-top:5px;">
			                				사실확인 접수 일자: <%=AddUtil.ChangeDate2(notice_dt) %>
			                			</li>
			                			<%} %>
			                			<% if(!paid_no.equals("")){ %>
			                			<li style="padding-top:5px;">
			                				고지서 번호: <%= paid_no%>
			                			</li>
			                			<%} %> --%>
			                			<% if( !vio_pla.equals("") ){ %>
			                			<li style="padding-top:5px;">
			                				위반 장소: <%= vio_pla %>
			                			</li>
			                			<%} %>
			                			
			                			<% if( !vio_dt.equals("") ){ %>
			                			<%
					                		String vio_dt_d = "";
										  	String vio_dt_h = "";
											String vio_dt_m = "";
											if( vio_dt.length() >= 8 ){
												vio_dt_d = AddUtil.ChangeDate2(vio_dt.substring(0,8));
											}
											if( vio_dt.length() >= 10 ){
												vio_dt_h = vio_dt.substring(8,10);
											}
											if( vio_dt.length() >= 12 ){
												vio_dt_m = vio_dt.substring(10,12);
											}
										%>
										<li style="padding-top:5px;">
			                				위반 일시: <%= vio_dt_d%> <%=vio_dt_h%>시 <%=vio_dt_m%>분
			                			</li>
			                			<%} %>
			                			
			                			<% if( !vio_st.equals("") ){ %>
			                			<li style="padding-top:5px;">
			                				위반 내용: <%if( vio_st.equals("1") ){%>도로교통법<%} 
			                								else if( vio_st.equals("2") ){%>유료도로법<%}
			                								else if( vio_st.equals("3") ){%>주차장법<%} 
			                								else if( vio_st.equals("4") ){%>장애인전용주차구역<%} 
			                								else if( vio_st.equals("5") ){%>폐기물관리법 <%} %>
			                								<%if( !vio_cont.equals("") ) {%> / <%= vio_cont %> <%} %>
			                			</li>
			                			<%} %>
			                			
			                			<% if( !FineGovBn.getGov_nm().equals("") ){ %>
			                			<li style="padding-top:5px;">
			                				청구 기관: <%=FineGovBn.getGov_nm()%>
			                				<%if( !FineGovBn.getTel().equals("") ){%>&nbsp;(<%=FineGovBn.getTel()%>)<%} %>
			                			</li>
			                			<%} %>
			                			
			                			<%-- <% if(!obj_end_dt.equals("")){ %>
			                			<li style="padding-top:5px;">
			                				의견진술기한: <%= AddUtil.ChangeDate2(obj_end_dt)%>까지
			                			</li>
			                			<%} %> --%>
			                			<%-- <% if(!doc_id.equals("") || !obj_dt1.equals("")){ %>
			                			<li style="padding-top:5px;">
			                				공문: <%if(!doc_id.equals("")) {%>
			                					[문서번호]: <%= doc_id %>
			                					 <%if(!doc_dt.equals("")) {%>&nbsp; [시행일자]: <%=AddUtil.ChangeDate2(doc_dt)%> <%} %>
			                					 <%if(!print_dt.equals("")) {%>&nbsp; [인쇄일자]: <%=AddUtil.ChangeDate2(print_dt)%> <%} %>
			                					<br>
			                					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			                					<%} %>
			                				<%if(!obj_dt1.equals("")){%>
                      							[이의신청]<% if(!obj_dt1.equals("")) {%> 1차: <%=AddUtil.ChangeDate2(obj_dt1)%> &nbsp; <%} %>
                      							<% if(!obj_dt2.equals("")) {%> 2차: <%=AddUtil.ChangeDate2(obj_dt2)%> &nbsp;<%} %>
                      							<% if(!obj_dt3.equals("")) {%> 3차: <%=AddUtil.ChangeDate2(obj_dt3)%><%} %>
    		    							<%}%>
			                			</li>
			                			<%} %> --%>
			                		</ul>
			                	</td>
			                </tr>
			                <%} %>
			                
			                <tr>
			                	<td align="center" style="padding: 30px;">
		                	<%if(!seq.equals("")){%>
		                    	 <%	if(file_type.equals("image/jpeg")||file_type.equals("image/pjpeg")/* ||file_type.equals("application/pdf") */){%>
			                    	 <a  style="background-color:#6d758c;font-size:12px;cursor:pointer; border-radius:8px; color:#fff; border:0; outline:0; padding:5px 8px; margin:3px; text-decoration:none; "
			                    	 href="https://fms3.amazoncar.co.kr/fms2/attach/imgview_print_email.jsp?CONTENT_CODE=<%=content_code%>&SEQ=<%=seq%>&S_GUBUN=<%=file_size%>">안내문 보기</a>									 
								 <%	}else{%>
								 	 <a  style="background-color:#6d758c;font-size:12px;cursor:pointer; border-radius:8px; color:#fff; border:0; outline:0; padding:5px 8px; margin:3px; text-decoration:none; "
			                    	 href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq%>">안내문 다운로드</a>									 
								 <%	}%>
							<%}%>	 
			                	</td>
			                </tr>
                		</table>
                	</td>
                </tr>
            </table>
        </td>
    </tr>   
	<tr>
		<td align=center height=50 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span></span></td>
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
                    <td width=35>&nbsp;</td>
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=513><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
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
</body>
</html>

