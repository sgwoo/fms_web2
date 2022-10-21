<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.call.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	PollDatabase p_db = PollDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	String g_fm = "1";
	String st_nm = "";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("st_nm") != null)	st_nm = request.getParameter("st_nm");
	
	Vector vt = p_db.getCarServiceCallAll(dt, ref_dt1, ref_dt2, gubun2, gubun3, gubun4, sort, st_nm, ck_acar_id);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
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
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}

//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body onLoad="javascript:init()">
<form name="form1">
<table border=0 cellspacing=0 cellpadding=0 width="1530">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1530">
            	<tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;' width=220> 
                          <table border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td width=50 class=title >연번</td>
                                <td width=50 class=title>선택</td>
                                <td width=120 class=title>계약번호</td>
                            </tr>
                        </table>
                    </td>
			        <td class=line width=1330>
			        	<table  border=0 cellspacing=1 width="100%">
                            <tr> 
                              	<td width=100 class=title > 정비일</td>
                              	<td width=70 class=title>차량구분</td>
                                <td width=150 class=title>차종</td>
                                <td width=150 class=title>상호</td>
                                <td width=90 class=title>차량이용자</td>
                                <td width=100 class=title>연락처</td>
                                <td width=50 class=title>결재</td>
                                <td width=80 class=title>금액</td>
                                <td width=270 class=title>내역</td>
                           		<td width=50 class=title>기간</td>
                                <td width=80 class=title>대여구분</td>
                                <td width=80 class=title>대여방식</td>
                                <td width=60 class=title>결재자</td>
                            </tr>
                        </table>
			        </td>
				</tr>
<%	if(vt_size > 0){%>
         		<tr>            		
		            <td class=line  id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=220>
    		              <% for (int i = 0 ; i < vt_size ; i++){
    							Hashtable ht = (Hashtable)vt.elementAt(i);
    										
    					  %>
		                    <tr class=line> 
        		                <td align="center" width=50><%= i+1%></td>
        		                <td align="center" width=50>
        		                  <%  if (String.valueOf(ht.get("GUBUN")).equals("9") ) {  %>   
        		                  &nbsp;
        		                  <%} else if (String.valueOf(ht.get("GUBUN")).equals("1") ) {  %>      
        		                   &nbsp;
        		                  <%} else { %>  
        		                 <input type="checkbox" name="ch_all" value="<%=ht.get("RENT_MNG_ID")%>^<%=ht.get("RENT_L_CD")%>^<%=ht.get("CAR_MNG_ID")%>^<%=ht.get("SERV_ID")%>^<%=ht.get("P_GUBUN")%>" > 
        		                 <% } %>
        		                 </td> 
        		  				   <%  if (String.valueOf(ht.get("GUBUN")).equals("9") ) {  %>           
        				          		   <td align="center" width=120>&nbsp;<%=ht.get("RENT_L_CD") %> </td>    	
        				           <%} else if (String.valueOf(ht.get("GUBUN")).equals("1") ) {  %>           
        				          		   <td align="center" width=120><font color="red">&nbsp;<%=ht.get("RENT_L_CD") %> </font></td>    		   
        				           <%} else { %> 
        				                   <td align="center" width=120><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SERV_ID")%>', '<%=ht.get("P_GUBUN")%>','<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>')">&nbsp;<%=ht.get("RENT_L_CD")%></a></td>   
        				           <% } %>  
		                    </tr>
		             <%}%> 
		                </table>
		            </td>            		            		
            		<td class=line>
            			<table border=0 cellspacing=1 width=1330>
                          <% for (int i = 0 ; i < vt_size ; i++){
            					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                          <tr> 
                                                 
                            <td width=100 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                            <td width=70 align="center"><%=ht.get("CAR_GU")%></td>
                            <td width=150 align="left"><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),11) %></span></td>
                            <td width=150 align="center"><span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
                            <td width=90 align="center"><span title="<%=ht.get("CALL_T_NM")%>"><%=Util.subData(String.valueOf(ht.get("CALL_T_NM")), 4)%></span></td>
	                        <td width=100 align="center"><%=ht.get("CALL_T_TEL")%></td>
	                        <td width=50 align="center"><%=ht.get("P_GUBUN") %></td>          
	                        <td width=80 align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%> 원</td>          
	                        <td width=270 align="left"><%=Util.subData(String.valueOf(ht.get("ACCT_CONT")), 20) %></td>                       
                            <td width=50 align="center"><%=ht.get("CON_MON")%></td>
                            <td width=80 align="center"><%=ht.get("CAR_ST")%></td>				
                            <td width=80 align="center"><%=ht.get("RENT_WAY")%></td>								
                            <td width=60 align="center"><%=ht.get("USER_NM")%></td>								
                          </tr>
                          <%}%>
                        </table>
			        </td>            		            		
            	</tr>
<%}%>
<%	if(vt_size == 0){%>
	            <tr>            		
                    <td class=line id='D1_col' style='position:relative;'> 
                        <table border=0 cellspacing=1 width=220>
                            <tr> 
                                <td align="center" width=210 colspan=3></td>               
                            </tr>
                        </table>
                    </td>            		            		
                    <td class=line>
                        <table border=0 cellspacing=1 width=1330>
            				<tr>
            					<td> &nbsp;등록된 데이타가 없습니다.</td>
            			    </tr>
            			</table>
            		</td>            		            		
                </tr>
<%}%>
            </table>
        </td>
    </tr>
</table>

<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="serv_id" value="">
<input type="hidden" name="rpt_no" value="">
<input type="hidden" name="p_gubun" value="">
<input type="hidden" name="firm_nm" value="">
<input type="hidden" name="client_nm" value="">
<input type="hidden" name="imm_amt" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='g_fm' value="1">
<input type='hidden' name='dt' value="">
<input type='hidden' name='gubun2' value="">
<input type='hidden' name='ref_dt1' value="">
<input type='hidden' name='ref_dt2' value="">
</form>
</body>
</html>