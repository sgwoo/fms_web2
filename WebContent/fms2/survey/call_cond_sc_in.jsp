<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.call.*" %>

<%
	PollDatabase p_db = PollDatabase.getInstance();
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//사용자ID
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	Vector vt = p_db.NgetRentCondAll(dt, ref_dt1, ref_dt2, gubun2, sort, s_kd, t_wd, user_id);
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


//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

function upd_call( m_id, l_cd)
	{
		var theForm = document.CarRegDispForm;
		
								
		if(confirm('대표통화완료처리 하시겠습니까?'))
		{		
			theForm.target = 'i_no';
			theForm.action = "updateReqCall_a.jsp?m_id="+m_id+"&l_cd="+l_cd;
			theForm.submit();
		}		
	
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="1900">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1900">
            	<tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;' width=12%> 
                        <table border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td width=20% class=title    style='height:30'>연번</td>
                                <td width=30% class=title    style='height:30'>대표</td> 
                                <td width=50% class=title>계약번호</td>
                            </tr>
                        </table>
                    </td>
			        <td class=line width=88%>
			        	<table  border=0 cellspacing=1 width="100%">
                          <tr> 
                          	<td width=6% class=title>콜등록일</td>
                          	<td width=4% class=title>계약구분</td>
                            <td width=6% class=title>계약일</td>
                           	<td width=4% class=title>차량구분</td>
                            <td width=5% class=title>영업구분</td>
                            <td width=4% class=title>영업사원</td>
                            <td width=4% class=title>출고사원</td>
                            <td width=4% class=title>최초영업</td>
                            <td width=4% class=title>영업담당</td>
                           	<td width=6% class=title>대여개시일</td>
                            <td width=9% class=title>상호</td>
                            <td width=5% class=title>계약자</td>
                            <td width=9% class=title>차종</td>
                            <td width=5% class=title>출고일</td>
                            <td width=5% class=title>등록일</td>
                         	<td width=4% class=title>기간</td>
                            <td width=3% class=title>대여구분</td>				
                            <td width=4% class=title>대여방식</td>
                            <td width=4% class=title>관리담당</td>	
                            <td width=6% class=title>등록자</td>								
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
                          <!--   
                          <%if(String.valueOf(ht.get("R_ANSWER")).equals("Y")){%>통화 
                         <%     if(String.valueOf(ht.get("RR_ANSWER")).equals("Y")){%>완료  
                          <%    }else{%> 
		                 <a href="javascript:upd_call('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" title='대표통화처리'><%=ht.get("RR_ANSWER")%></a>   
		        <%}%>                                                 
                            <% } %> -->
                         </td>
                            <td align="center" width=50%><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%if(AddUtil.parseInt(AddUtil.ChangeString(String.valueOf(ht.get("ANSWER_DATE")))) >= 20170101){%><%=ht.get("RENT_ST")%><%}else{%><%}%>','<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>')"><%=ht.get("RENT_L_CD")%></a></td>
                          </tr>
              <%}%>
                        </table>
                   </td>            		            		
            	    <td class=line width=88%>
            			<table border=0 cellspacing=1 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                          <tr> 
                            <td width=6% align="center"><%=ht.get("ANSWER_DATE")%></td>
                            <td width=4% align="center"><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%></td>	
                            <td width=6% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                            <td width=4% align="center"><%=ht.get("CAR_GU")%></td>	
                            <td width=5% align="center"><%=ht.get("BUS_ST")%></td>
                            <td width=4% align="center"><span title="<%=ht.get("EMP_NM")%>"><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 4)%></span></td>
                            <td width=4% align="center"><span title="<%=ht.get("CHUL_NM")%>"><%=Util.subData(String.valueOf(ht.get("CHUL_NM")), 4)%></span></td>
                            <td width=4% align="center"><%=ht.get("BUS_NM")%></td>
                            <td width=4% align="center"><%=ht.get("BUS_NM2")%></td>
                            <td width=6% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                            <td width=9% align="left">&nbsp;<span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
                            <td width=5% align="center"><span title="<%=ht.get("CLIENT_NM")%>"><%=Util.subData(String.valueOf(ht.get("CLIENT_NM")), 3)%></span></td>
                            <td width=9% align="left"><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),10) %></span></td>
                            <td width=5% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
                            <td width=5% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                            <td width=4% align="center"><%=ht.get("CON_MON")%>개월</td>
                            <td width=3% align="center"><%=ht.get("CAR_ST")%></td>				
                            <td width=4% align="center"><%=ht.get("RENT_WAY")%></td>
                            <td width=4% align="center"><%=ht.get("MNG_NM")%></td>	
                            <td width=6% align="center"><span title="<%=ht.get("CALL_NM")%>"><%=Util.subData(String.valueOf(ht.get("CALL_NM")), 6)%></span></td>								
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

<form action="./register_frame.jsp" name="CarRegDispForm" method="POST">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='g_fm' value="1">
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</form>
</body>
</html>