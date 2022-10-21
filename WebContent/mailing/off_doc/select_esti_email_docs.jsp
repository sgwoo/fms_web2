<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%
	String ua = request.getHeader("User-Agent");
	boolean isChrome = false;
	if(ua.contains("Chrome")){
		isChrome = true;
	}
	/* if(isChrome){
		request.setCharacterEncoding("UTF-8");
	}else{
		request.setCharacterEncoding("EUC-KR");
	} */
	String pack_id 	= request.getParameter("pack_id")==null?"":request.getParameter("pack_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_nm 	= request.getParameter("est_nm")==null?"고객":request.getParameter("est_nm");
	String send_seq = request.getParameter("send_seq")==null?"":request.getParameter("send_seq");	
	String memo = request.getParameter("memo")==null?"":request.getParameter("memo");	
		
	String[] send_seq_result =  send_seq.split(",");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);

%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 업무서식 안내서</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #63676a}
.style3 {color: #ff8004}
.style4 {color: #c09b33; font-weight: bold;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<link href=http://fms1.amazoncar.co.kr/include/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--
//New 로그인
	function getLogin2(member_id, pwd){	
		var w = 450;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN="https://fms.amazoncar.co.kr/service/index.jsp?name="+member_id+"&passwd="+pwd;	
		window.open(SUBWIN, "InfoUp1", "left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes");		
		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
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
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top_est_file.gif></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35 align="left"><span class=style2><span class=style1><b><%=est_nm%> </b>님</span></span></td>
                    <td width=221 align="left"><span class=style2><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%if(user_bean.getUser_nm().equals("권웅철")){%>유재석<%}else{%><%=user_bean.getUser_nm()%><%}%>&nbsp;&nbsp;<%=user_bean.getUser_m_tel()%></span></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine2.gif>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=636>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>

                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18 align="left"><span class=style2>형식 아이콘을 누르시면 해당 파일이 <font color=red>다운로드</font>됩니다.</span></td>
                            </tr>
                            <tr>
                                <td height=18 align="left"><span class=style2>아마존카를 이용해 주셔서 진심으로 감사드리며, 궁금하신 사항이 있으시면 담당자에게 전화주시기 바랍니다.</span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_est_file.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                	<td align=center>
                		<table width=648 border=0 cellspacing=0 cellpadding=0>
                			<tr>
                        		<td height=2 bgcolor=656e7f colspan=2></td>
                        	</tr>
                        </table>
      				</td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            <tr>
                                <td bgcolor=f2f2f2 height=30 width=450 align=center><span class=style1>첨부파일</span></td>
                                <td bgcolor=f2f2f2 align=center><span class=style1>형식</span></td>
                            </tr>
                            

                                 <%
                                		for(int i=0;i<send_seq_result.length;i++){
                                	 		Vector attach_vt = c_db.getAcarAttachFileList(AddUtil.parseInt(send_seq_result[i]));	
																			int vt_size = attach_vt.size();
																			
																			if(vt_size>0){
																			
													        	 		Hashtable ht = (Hashtable)attach_vt.elementAt(0);
												        		 		String sfile_name = ht.get("FILE_NAME")+"";
																	 	 		sfile_name = sfile_name.substring(0,sfile_name.lastIndexOf("."));
																	 	 
																	 	 		String sfile_type = ht.get("FILE_NAME")+"";
																		 		sfile_type = sfile_type.substring(sfile_type.lastIndexOf(".")+1,sfile_type.length());
																		 		String sfile_size = ht.get("FILE_SIZE")+"";
												        		 %>
																<tr>
																		<td bgcolor=ffffff height=30 align="left">&nbsp;<span class=style2><%=sfile_name%></span></td>
		                                <td bgcolor=ffffff align=center>&nbsp;
                               		  <span class=style2>
                               		  	<a href="https://fms3.amazoncar.co.kr/fms2/attach/download2.jsp?SEQ=<%=ht.get("SEQ")%>&SIZE=<%=sfile_size%>" target='_blank'><img src="http://fms1.amazoncar.co.kr/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a></span>
                               		  </td>
                            		</tr>
															  <%  	} %>
															  <%  } %>
                        </table>
                    </td>
                </tr>
                 
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_memo.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                        	<tr>
                        		<td height=2 bgcolor=656e7f></td>
                        	</tr>
                            <tr>
                            	<td>
                            		<table width=648 border=0 cellspacing=0 cellpadding=20 bgcolor=f2f2f2>
                            			<tr>
                                			<td><span class=style1><%=memo%></span></td>
                                		</tr>
                                	</table>
                                </td>
                            </tr>
                            <tr>
                            	<td height=1 bgcolor=d6d6d6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<tr>
					<td height=60></td>
				</tr>                
            </table>
        </td>
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
                    <td width=85><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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
</body>
</html>