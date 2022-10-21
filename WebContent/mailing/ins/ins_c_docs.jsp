<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.insur.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase i_db = InsDatabase.getInstance();
	
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	
	//고객의 모든 차량 리스트
	Vector client_vt = i_db.getIjwListmailing(client_id);		
	int client_vt_size = client_vt.size();		
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	
	
	for(int k=0;k<1;k++){							
		Hashtable ht = (Hashtable)client_vt.elementAt(k);
		//발신자 사용자 정보 조회
		user_bean 	= umd.getUsersBean(String.valueOf(ht.get("BUS_ID2")));
		user_id = user_bean.getUser_id();
	}
	
	String insmng_id = nm_db.getWorkAuthUser("부산보험담당");
	
	UsersBean insmng_bean 	= umd.getUsersBean(insmng_id);
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>임직원 전용 자동차 보험 가입 요청서</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #333333; line-height:19px;}
.style3 {color: #ff8004}
.style4 {color: #a74073; font-weight: bold;font-size:14px;}
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
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--	
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
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/layout_top_ins_file.gif></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35 align="left" style="font-family:nanumgothic;font-size:12px;"><b><%=client.getFirm_nm()%> </b>님</td>
                    <td width=221 align="left" style="font-family:nanumgothic;font-size:12px;"><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%if(user_bean.getUser_nm().equals("권웅철")){%>유재석<%}else{%><%=user_bean.getUser_nm()%><%}%>&nbsp;&nbsp;<%=user_bean.getUser_m_tel()%> </td>
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
                    <td width=636 align=center>
                        <table width=98% border=0 cellspacing=0 cellpadding=0>

                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                            	<td style="font-family:nanumgothic;font-size:13px;">2016년 세법 개정으로 4월 1일부터는 법인에서 이용하는 장기렌트, 리스, 자가소유 업무용승용차  관련비용을 회사 경비로 처리하려면
                            	<b>임직원 전용 자동차보험에 가입</b>하여야 합니다. 
                            	<br>자세한 내용은 첨부파일 (업무용승용차 관련비용의 손비처리 안내문.pdf)을 참고하시기 바랍니다.</td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                           
                            <tr>
                            	<td style="font-family:nanumgothic;font-size:13px;">아래 <span style="color: #a74073; font-weight: bold;font-size:14px;">[임직원 전용보험 가입 요청서]</span>를 작성하시어 기존 보험 만료일 <b>2일전까지는 아마존카<br>
                            	(FAX. <%=user_bean.getI_fax()%>)
                            	<%if(user_bean.getI_fax().equals("")){%><%=insmng_bean.getI_fax()%>)<%}%>
                            	</b>로 보내주시기 바랍니다.</span></td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                            <tr>
                                <td height=18 align="left" style="font-family:nanumgothic;font-size:13px;">아마존카를 이용해 주셔서 진심으로 감사드리며, 궁금하신 사항이 있으시면 담당자에게 전화주시기 바랍니다.</td>
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
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/ins/images/e_bar_ins_file.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
	                        <tr>
	                        	<td height=2 bgcolor=656e7f colspan=4></td>
	                        </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=40 width=15% align=center style="font-family:nanumgothic;font-size:12px;">기존 보험<br>만료일</td>
                                <td bgcolor=f2f2f2 width=35% align=center style="font-family:nanumgothic;font-size:12px;">차종</td>
                                <td bgcolor=f2f2f2 width=25% align=center style="font-family:nanumgothic;font-size:12px;">차량번호</td>
                                <td bgcolor=f2f2f2 width=25% align=center style="font-family:nanumgothic;font-size:12px;">임직원 전용보험<br>가입대상차종 여부</td>
                            </tr>
                			<%														
							for(int k=0;k<client_vt_size;k++){
							
        							  Hashtable ht = (Hashtable)client_vt.elementAt(k);
        							          						  
 					%>
        						 <tr bgcolor=#ffffff>
        						 		<td height=40 align=center style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INS_EXP_DT")))%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;color:#a74073;"><%=ht.get("CAR_NO")%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("COM_EMP_YN")%></td>
										 </tr>
										<% }%>                            
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                	<td style="font-family:nanumgothic;font-size:12px;">&nbsp;※ 임직원 전용보험 가입대상여부가 X인 경우는 경차 또는 9인승이상 차량 또는 화물에 해당되기 때문에 가입할 필요가<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 없습니다.</span></td>
                </tr>
                <tr>
                    <td height=35></td>
                </tr>
                <tr>
                	<td align=center><a href=http://fms1.amazoncar.co.kr/fms2/lc_rent/newcar_doc_ins.jsp?id1=<%=client_id%>&id2=<%=user_id%> target="_blank"><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/btn_ins_app.gif border=0></a></td>
                </tr>
                 
                <tr>
                    <td height=20></td>
                </tr>

				<tr>
					<td height=30></td>
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
                    <td width=85><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
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