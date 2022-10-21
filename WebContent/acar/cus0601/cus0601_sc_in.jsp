<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.cus0601.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	
	if (!gubun1.equals("")){
	} else {	
		if(t_wd.equals("")) return;
	}
	
	Vector vt = c61_db.getServ_offList_20090528(s_kd, t_wd, gubun1, sort_gubun, sort, "1", br_id);
	int vt_size = vt.size();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
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
	function init()
	{		
		setupEvents();
	}
//-->
</script>
</head>

<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=2100>
	            <tr id='tr_title' style='position:relative;z-index:1'>		            
                    <td width=22% class='line' id='td_title' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <% if(!auth_rw.equals("1")){ %>
                                <td width='8%' class='title' >&nbsp;</td>
                                <% } %>
                                <td width='9%' class='title' height="35" >연번</td>
                                <td width='19%' class='title' >지정업체</td>
                                <td width='10%' class='title' height="35" >등급</td>
                                <td width='29%' class='title' >상호</td>
                                <td width='15%' class='title' height="35" >대표자</td>
                            </tr>
                        </table>
                    </td>		
                    <td width=78% class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                
                                <td width='7%' class='title'>사업자번호</td>
                                <td width="10%" class='title'>계좌번호</td>
                                <td width="10%" class='title'>예금주</td>
                                <td width='6%' class='title'>업태</td>
                                <td width='7%' class='title'>종목</td>
                                <td width='6%' class='title'>전화번호</td>
                                <td width='6%' class='title'>팩스번호</td>
                                <td width="15%" class='title'>주소</td>
                                <td width='5%' class='title'>총정비건수</td>
                                <td width='7%' class='title'>총정비금액</td>
                            </tr>
                        </table>
 		            </td>
	            </tr>
<%if(vt_size !=0 ){%>
	            <tr>            
                    <td class='line' id='td_con' style='position:relative;' width=22%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
              <% for(int i=0; i< vt_size; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
                            <tr> 
                            <% if(!auth_rw.equals("1")){ %>
                                <td width='8%' align='center'>
								  <%if(Long.parseLong(String.valueOf(ht.get("SERV_CNT")))==0){%>
                                  <a href="javascript:parent.ServOffDel('<%=ht.get("OFF_ID")%>')" onMouseOver="window.status=''; return true"> 
                                  <img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
                                  <% } %>
                                </td>
                            <% } %>
                                <td width='9%' align='center'><%=i+1%></td>
                                <td width='19%' align='center'><%=ht.get("CAR_COMP_NM")%></td>
                                <td width='10%' align='center'><%=ht.get("OFF_ST_NM")%></td>
                                <td width='29%' align='left'><span title='<%=ht.get("OFF_NM")%>'>&nbsp;<a href="javascript:parent.view_detail('<%=ht.get("OFF_ID")%>')"><%=AddUtil.subData(String.valueOf(ht.get("OFF_NM")),10)%></a></span></td>
                                <td width='15%%' align='center'><span title="<%=ht.get("OWN_NM")%>"><%=AddUtil.subData(String.valueOf(ht.get("OWN_NM")),3)%></span></td>
                            </tr>
                          <%}%>
                            <tr> 
                            <% if(!auth_rw.equals("1")){ %>
                                <td  class='title' width='8%' align='center'>&nbsp;</td>
                                <% } %>
                                <td  class='title' width='9%' align='center'>&nbsp;</td>
                                <td  class='title' width='19%' align='center'>&nbsp;</td>
                                <td  class='title' width='10%' align='center'>&nbsp;</td>
                                <td  class='title' width='29%' align='center'>&nbsp;</td>
                                <td  class='title' width='15%' align='center'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td class='line' width=78%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                          <% for(int i=0; i< vt_size; i++){
						 Hashtable ht = (Hashtable)vt.elementAt(i);
            	%>
                            <tr>
                                
                                <td width='7%' align='center' ><%=AddUtil.ChangeEnt_no(String.valueOf(ht.get("ENT_NO")))%></td>
                                <td width="10%" align='left' ><span title="<%=ht.get("BANK")%>&nbsp;<%=ht.get("ACC_NO")%>">&nbsp;<%=ht.get("BANK")%>&nbsp;<%=ht.get("ACC_NO")%></span></td>
                                <td width="10%" align='left' ><span title="<%=ht.get("ACC_NM")%>">&nbsp;<%=AddUtil.subData(String.valueOf(ht.get("ACC_NM")),15)%></span></td>
                                <td width='6%' align='center'><span title="<%=ht.get("OFF_STA")%>"><%=AddUtil.subData(String.valueOf(ht.get("OFF_STA")),5)%></span></td>
                                <td width='7%' align='center'><span title="<%=ht.get("OFF_ITEM")%>"><%=AddUtil.subData(String.valueOf(ht.get("OFF_ITEM")),6)%></span></td>
                                <td width='6%' align='center' ><%=ht.get("OFF_TEL")%></td>
                                <td width='6%' align='center' ><%=ht.get("OFF_FAX")%></td>
                                <td width="15%" align='left' ><span title="<%=ht.get("OFF_POST")%>&nbsp;<%=ht.get("OFF_ADDR")%>">&nbsp;<%=ht.get("OFF_POST")%>&nbsp;<%=AddUtil.subData(String.valueOf(ht.get("OFF_ADDR")),20)%></span></td>
                            		<td width='5%' align='right' ><%=AddUtil.parseDecimal(String.valueOf(ht.get("SERV_CNT")))%>&nbsp;건&nbsp;&nbsp;</td>
                                <td width='7%' align='right' ><%=AddUtil.parseDecimal(Long.parseLong(String.valueOf(ht.get("SERV_AMT"))))%>&nbsp;원&nbsp;&nbsp;</td>
                            </tr>
                          <%}%>
                            <tr>
                                <td  class='title' width='7%' align='center' >&nbsp;</td>
                                <td  width="10%" align='center'  class='title'>&nbsp;</td>
                                <td  width="10%" align='center'  class='title'>&nbsp;</td>
                                <td  class='title' width='6%' align='center' >&nbsp;</td>
                                <td  class='title' width='7%' align='center' >&nbsp;</td>
                                <td  class='title' width='6%' align='center' >&nbsp;</td>
                                <td  class='title' width='6%' align='center' >&nbsp;</td>
                                <td  width="15%" align='center'  class='title'>&nbsp;</td>
                                <td  class='title' width='5%' align='center' >&nbsp;</td>
                                <td  class='title' width='7%' align='center' >&nbsp;</td>
                            </tr>
                        </table>
		            </td>
            	</tr>
            <%}else{%>
            	<tr>	        
                    <td class='line' id='td_con' style='position:relative;' width=32%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                          <tr> 
                            <td align='center'></td>
                          </tr>
                        </table>
                    </td>
            	    <td class='line' width=78%> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 업체가 없읍니다.</td>
                            </tr>          
                        </table>
            		</td>
            	</tr>
            <%}%>
            </table>
        </td>
    </tr>
</table>		
</table>
</body>
</html>
