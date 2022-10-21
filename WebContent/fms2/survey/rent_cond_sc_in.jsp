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
	
	Vector vt = p_db.getRentCondCallAll(dt, ref_dt1, ref_dt2, gubun2, gubun3, gubun4, sort, st_nm, ck_acar_id);
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
<table border=0 cellspacing=0 cellpadding=0 width="1770">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1770">
            	<tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;'> 
                        <table border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td width=25% class=title>연번</td>
                                <td width=25% class=title>선택</td>
                                <td width=50% class=title>계약번호</td>
                            </tr>
                        </table>
                    </td>
			        <td class=line>
			        	<table  border=0 cellspacing=1 width="1560">
                            <tr> 
                                <td width=100 class=title>대여개시일</td>
                              	<td width=70 class=title>계약구분</td>
                               	<td width=100 class=title>계약일</td>
                              	<td width=70 class=title>차량구분</td>
                              	<td width=90 class=title>영업구분</td>
                                <td width=60 class=title>영업사원</td>
                                <td width=60 class=title>출고사원</td>
                                <td width=60 class=title>최초영업</td>
                                <td width=60 class=title>영업담당</td>
                                <td width=120 class=title>상호</td>
                                <td width=90 class=title>계약자</td>
                                <td width=150 class=title>차종</td>
                                <td width=80 class=title>출고일</td>
                                <td width=80 class=title>등록일</td>
                           		<td width=50 class=title>기간</td>
                                <td width=80 class=title>대여구분</td>				
                                <td width=80 class=title>대여방식</td>
                                <td width=60 class=title>관리담당</td>								
                            </tr>
                        </table>
			        </td>
				</tr>
<%	if(vt_size > 0){%>
         		<tr>            		
		            <td class=line  id='D1_col' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=210>
    		              <% for (int i = 0 ; i < vt_size ; i++){
    							Hashtable ht = (Hashtable)vt.elementAt(i);
    										
    					  %>
		                    <tr class=line> 
        		                <td align="center" width=25%><%= i+1%></td>
        		                <td align="center" width=25%>
        		                  <%  if (String.valueOf(ht.get("GUBUN")).equals("9") ) {  %>   
        		                  &nbsp;
        		                  <%} else if (String.valueOf(ht.get("GUBUN")).equals("1") ) {  %>      
        		                   &nbsp;
        		                  <%} else { %>  
        		                 <input type="checkbox" name="ch_all" value="<%=ht.get("RENT_MNG_ID")%>^<%=ht.get("RENT_L_CD")%>" > 
        		                 <% } %>
        		                 </td> 
        		  				   <%  if (String.valueOf(ht.get("GUBUN")).equals("9") ) {  %>           
        				          		   <td align="center" width=50%>&nbsp;<%=ht.get("RENT_L_CD") %> </td>    	
        				           <%} else if (String.valueOf(ht.get("GUBUN")).equals("1") ) {  %>           
        				          		   <td align="center" width=50%><font color="red">&nbsp;<%=ht.get("RENT_L_CD") %> </font></td>    		   
        				           <%} else { %> 
        				                   <td align="center" width=50%><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>','<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>')">&nbsp;<%=ht.get("RENT_L_CD")%></a></td>   
        				           <% } %>  
		                    </tr>
		             <%}%> 
		                </table>
		            </td>            		            		
            		<td class=line>
            			<table border=0 cellspacing=1 width=1560>
                          <% for (int i = 0 ; i < vt_size ; i++){
            					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                          <tr> 
                          <td width=100 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                            <td width=70 align="center" class=b><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%></td>	
                            <td width=100 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                            <td width=70 align="center"><%=ht.get("CAR_GU")%></td>	
                            <td width=90 align="center"><%=ht.get("BUS_ST")%></td>
                            <td width=60 align="center"><span title="<%=ht.get("EMP_NM")%>"><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 4)%></a></span></td>
                            <td width=60 align="center"><span title="<%=ht.get("CHUL_NM")%>"><%=Util.subData(String.valueOf(ht.get("CHUL_NM")), 4)%></a></span></td>
                            <td width=60 align="center"><%=ht.get("BUS_NM")%></td>
                            <td width=60 align="center"><%=ht.get("BUS_NM2")%></td>
                            <td width=120 align="left">&nbsp;<span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></a></span></td>
                            <td width=90 align="center"><span title="<%=ht.get("CLIENT_NM")%>"><%=Util.subData(String.valueOf(ht.get("CLIENT_NM")), 4)%></a></span></td>
                            <td width=150 align="left"><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),11) %></span></td>
                            <td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
                           	<td width=80 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                            <td width=50 align="center"><%=ht.get("CON_MON")%>개월</td>
                            <td width=80 align="center"><%=ht.get("CAR_ST")%></td>				
                            <td width=80 align="center"><%=ht.get("RENT_WAY")%></td>								
                            <td width=60 align="center"><%=ht.get("MNG_NM")%></td>								
                          </tr>
                          <%}%>
                        </table>
			        </td>            		            		
            	</tr>
<%}%>
<%	if(vt_size == 0){%>
	            <tr>            		
                    <td class=line id='D1_col' style='position:relative;'> 
                        <table border=0 cellspacing=1 width=210>
                            <tr> 
                                <td align="center" width=210 colspan=3></td>               
                            </tr>
                        </table>
                    </td>            		            		
                    <td class=line>
                        <table border=0 cellspacing=1 width=1560>
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
<input type="hidden" name="rpt_no" value="">
<input type="hidden" name="firm_nm" value="">
<input type="hidden" name="client_nm" value="">
<input type="hidden" name="imm_amt" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='g_fm' value="1">

</form>
</body>
</html>