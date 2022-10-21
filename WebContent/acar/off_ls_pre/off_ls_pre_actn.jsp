<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.common.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="apprsl" scope="page" class="acar.offls_pre.Off_ls_pre_apprsl"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String id = request.getParameter("id")==null?"":request.getParameter("id");//actn_id
	
	ClientBean client = al_db.getClient(id);
	
	//LoginBean login = LoginBean.getInstance();
	//String user_id = login.getCookieValue(request, "acar_id");

	Vector tels = olpD.getTels(id);
	apprsl = olpD.getPre_apprsl(car_mng_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComBean[] insCom = c_db.getInsComAll();
%>
<html>
<head>
<title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function go_modify()
{
	var fm = document.form1;
	//var s_kd = fm.s_kd.value;
	//var t_wd = fm.t_wd.value;
	//var asc = fm.asc.value;
	fm.action='/acar/off_ls_pre/off_ls_pre_actn_u.jsp?';
	fm.submit();
}
function search_zip(str)
{
	window.open("/acar/common/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
}	
function set_o_addr()
{
	var fm = document.form1;
	if(fm.c_ho.checked == true)
	{
		fm.t_zip[1].value = fm.t_zip[0].value;
		fm.t_addr[1].value = fm.t_addr[0].value;
	}
	else
	{
		fm.t_zip[1].value = '';
		fm.t_addr[1].value = '';
	}
}
function reg_actn(){
	var fm = document.form1;
	fm.action = "/acar/off_ls_pre/off_ls_pre_actn_i.jsp";
	fm.submit();
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
// -->
</script>
</head>
<body>
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="id" value="<%=client.getClient_id()%>">
<input type="hidden" name="flag" value="no_open">
<input type="hidden" name="gubun" value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>  
            <% if(!id.equals("")){ %>
                <tr> 
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr> 
                                <td width="399"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기본정보</span></td>
                                <td align="right"> 
                                <%	//if(auth_rw.equals("R/W")){%>
                                <%//if(!client.getClient_id().equals("")){
                          //<a href="javascript:go_modify()" onMouseOver="window.status=''; return true"><img src="/images/up_info.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
            			  //}else{
            			  //<a href='javascript:reg_actn();' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" align="absmiddle" border="0"></a>
            			  //}
                          	//}%>
                                </td>
                            </tr>
                            <tr>
                                <td class=line2 colspan=2></td>
                            </tr>          
                            <tr> 
                                <td class="line" colspan="2"> 
                                    <table border="0" cellspacing="1" cellpadding="0" width="100%">
                                        <tr> 
                                            <td class='title' width='15%'> 고객구분 </td>
                                            <td width='19%'>&nbsp; 
                                      <%if(client.getClient_st().equals("1")) 		out.println("법인");
                          	else if(client.getClient_st().equals("2"))  out.println("개인");
                          	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                          	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                          	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");
            				else if(client.getClient_st().equals("6"))	out.println("경매장");%>
                                            </td>
                                            <td class='title' width='15%'>상호</td>
                                            <td width='18%'>
                                                <table width=100% cellspacing=0 cellpadding=3 border=0>
                                                    <tr>
                                                        <td><%=client.getFirm_nm()%></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class='title' width='15%'>대표자</td>
                                            <td width="18%">&nbsp;<%=client.getClient_nm()%></td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>주민등록번호(법인번호)</td>
                                            <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
                                            <td class='title'>사업자등록번호</td>
                                            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                                            <td class='title'>전화번호</td>
                                            <td>&nbsp;<%=client.getO_tel()%></td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>FAX</td>
                                            <td>&nbsp;<%=client.getFax()%></td>
                                            <td class='title'>Homepage</td>
                                            <td colspan='3'>&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>우편물 주소</td>
                                            <td colspan='5'>&nbsp; 
                                              <%if(!client.getHo_addr().equals("")){%>
                                              ( 
                                              <%}%>
                                              <%=client.getHo_zip()%> 
                                              <%if(!client.getHo_addr().equals("")){%>
                                              )&nbsp; 
                                              <%}%>
                                              <%=client.getHo_addr()%></td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>사업장 주소</td>
                                            <td colspan='5'>&nbsp; 
                                              <%if(!client.getO_addr().equals("")){%>
                                              ( 
                                              <%}%>
                                              <%=client.getO_zip()%> 
                                              <%if(!client.getO_addr().equals("")){%>
                                              )&nbsp; 
                                              <%}%>
                                              <%=client.getO_addr()%></td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>업태</td>
                                            <td>&nbsp;<%=client.getBus_cdt()%></td>
                                            <td class='title'>종목</td>
                                            <td>&nbsp;<%=client.getBus_itm()%></td>
                                            <td class='title'>개업년월일</td>
                                            <td>&nbsp;<%= client.getOpen_year()%></td>
                                        </tr>
                                        <tr> 
                                            <td class='title'> 특이사항 </td>
                                            <td colspan='5'> <table border="0" cellspacing="1" cellpadding="0" width=670 height='40'>
                                                <tr> 
                                                  <td><%=Util.htmlBR(client.getEtc())%> </td>
                                                </tr>
                                              </table></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td colspan="2"></td>
                            </tr>
                            <tr> 
                                <td colspan="2" ><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>담당자별 연락처</span></td>
                            </tr>
                            <tr>
                                <td class=line2 colspan=2></td>
                            </tr>   
                            <tr> 
                                <td class="line" colspan="2"> 
                                    <table border="0" cellspacing="1" cellpadding="0" width="100%">
                                        <tr> 
                                            <td class=title width=15%>구분</td>
                                            <td class=title width=19%>성명</td>
                                            <td class=title width=15%>직위</td>
                                            <td class=title width=18%>전화번호</td>
                                            <td class=title width=15%>FAX</td>
                                            <td class=title width=18%>휴대폰</td>
                                        </tr>
                                  <%for(int i=0; i<tels.size(); i++){
            				Hashtable ht = (Hashtable)tels.elementAt(i);%>
                                        <tr> 
                                            <td align='center'> <input type="hidden" name="actn_id" value="<%=ht.get("CLIENT_ID")%>"> 
                                              <input type="hidden" name="seq" value="<%=ht.get("SEQ")%>"> 
                                              <%=ht.get("GUBUN")%></td>
                                            <td align='center'> <input type='text' name='name'    size='12' maxlength='20' class='white' value="<%=ht.get("NAME")%>" readonly> 
                                            </td>
                                            <td align='center'> <input type='text' name='jikwi' size='12' maxlength='20' class='white' value="<%=ht.get("TITLE")%>" readonly> 
                                            </td>
                                            <td align='center'> <input type='text' name='tel'   size='12' maxlength='15' class='white' value="<%=ht.get("TEL")%>" readonly> 
                                            </td>
                                            <td align='center'> <input type='text' name='email' size='12' maxlength='15' class='white' value="<%=ht.get("FAX")%>" readonly> 
                                            </td>
                                            <td align='center'> <input type='text' name='fax' size='12' maxlength='15' class='white' value="<%=ht.get("MOBILE")%>" readonly> 
                                            </td>
                                        </tr>
                                  <%}%>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"></td>
                </tr>
              <% } %>		  
                <tr>
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험상태</span></td>
                </tr>
                <tr> 
                    <td width="100%"><iframe src="./off_ls_pre_actn_in_ins.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=id%>" name="in_ins" width="100%" height="60" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
                </tr>
                <tr> 
                    <td colspan="2"></td>
                </tr>
                <tr> 
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td width="350"><iframe src="./off_ls_pre_actn_in_doc.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=id%>" name="in_doc" width="100%" height="260" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
                                <td width="85">&nbsp; </td>
                                <td width="400"  valign=top> 
                                    <table width="400" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                            <td><iframe src="./off_ls_pre_actn_in_ass.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&id=<%=id%>" name="in_ass" width="100%" height="120" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table> 
        </td>
    </tr>
</table>
 </form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
