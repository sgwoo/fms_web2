<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.call.*" %>

<%
	PollDatabase p_db = PollDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	Vector vt = p_db.getServiceCallAll(dt, ref_dt1, ref_dt2, gubun2, sort, s_kd, t_wd);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
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


function upd_call( m_id, l_cd, c_id, serv_id)
{
	var theForm = document.CarRegDispForm;
										
	if(confirm('대표통화완료처리 하시겠습니까?') )
	{		
		theForm.target = 'i_no';
		theForm.action = "updateReqServCall_a.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&serv_id="+serv_id ;
		theForm.submit();
	}
}
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="1600">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1600">
            	<tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;' width=12%> 
                        <table border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td width=20% class=title >연번</td>
                                <td width=30% class=title    style='height:30'>대표</td> 
                                <td width=50% class=title>계약번호</td>
                            </tr>
                        </table>
                    </td>
			        <td class=line width=88%>
			        	<table  border=0 cellspacing=1 width="100%">
                          <tr> 
                          	            <td width=90 class=title  style='height:30'>콜등록일</td>
                         	            <td width=90 class=title>정비일</td>
	                            <td width=70 class=title>차량구분</td>                                                   
	                            <td width=170 class=title>차종</td>
	                            <td width=90 class=title>차량이용자</td>
	                            <td width=100 class=title>연락처</td>
	                            <td width=50 class=title>결재</td>	
	                             <td width=80 class=title>금액</td>	
	                            <td width=270 class=title>내역</td>	
	                            <td width=50 class=title>기간</td>
	                            <td width=80 class=title>대여구분</td>				
	                            <td width=80 class=title>대여방식</td>
	                            <td width=60 class=title>결재자</td>		
	                            <td width=80 class=title>등록자</td>						
                          </tr>
                        </table>
			        </td>
				</tr>
<%	if(vt_size > 0){%>
            	<tr>            		
                    <td class=line id='D1_col' style='position:relative;' width=12%> 
                        <table border=0 cellspacing=1 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                          <tr> 
                            <td align="center" width=20%><%= i+1%></td>
                               <td align="center" width=30%>
                          <%if(String.valueOf(ht.get("R_ANSWER")).equals("Y")){%>통화 
                         <%     if(String.valueOf(ht.get("RR_ANSWER")).equals("Y")){%>완료  
                          <%    }else{%> 
		                 <a href="javascript:upd_call('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SERV_ID")%>')" title='대표통화처리'><%=ht.get("RR_ANSWER")%></a>   
		        <%}%>                                                 
                            <% } %>
                         </td>
                            <td align="center" width=50%><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SERV_ID")%>')"><%=ht.get("RENT_L_CD")%></a></td>
                          </tr>
              <%}%>
                        </table>
                   </td>            		            		
            	    <td class=line width=88%>
            			<table border=0 cellspacing=1 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                          <tr> 
                            <td width=90 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ANSWER_DATE")))%></td>
                            <td width=90 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                            <td width=70 align="center"><%=ht.get("CAR_GU")%></td>
                            <td width=170 align="left"><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),14) %></span></td>
                            <td width=90 align="center"><%=Util.subData(String.valueOf(ht.get("CALL_T_NM")), 4) %></td>
	                        <td width=100 align="center"><%=ht.get("CALL_T_TEL")%></td>
	                        <td width=50 align="center"><%=ht.get("P_GUBUN")%></td>
	                         <td width=80 align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%> 원</td>          
	                        <td width=270 align="left"><%=Util.subData(String.valueOf(ht.get("ACCT_CONT")), 23) %></td>                       
                            <td width=50 align="center"><%=ht.get("CON_MON")%></td>
                            <td width=80 align="center"><%=ht.get("CAR_ST")%></td>				
                            <td width=80 align="center"><%=ht.get("RENT_WAY")%></td>								
                            <td width=60 align="center"><%=ht.get("USER_NM")%></td>		
                            <td width=80 align="center"><span title="<%=ht.get("CALL_NM")%>"><%=Util.subData(String.valueOf(ht.get("CALL_NM")), 6)%></span></td>										
                          </tr>
              <%}%>
                        </table>
			        </td>            		            		
            	</tr>
<%}%>
<%	if(vt_size == 0){%>
	            <tr>
            		
                    <td class=line id='D1_col' width=12% style='position:relative;'> 
                        <table border=0 cellspacing=1 width=100%>
                          <tr> 
                            <td align="center"></td>
                          </tr>
                        </table>
                    </td>            		            		
            		<td class=line width=88%>
            			<table border=0 cellspacing=1 width=100%>
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

<form  name="CarRegDispForm" method="POST">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="serv_id" value="">
<input type="hidden" name="p_gubun" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='g_fm' value="1">
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</form>
</body>
</html>