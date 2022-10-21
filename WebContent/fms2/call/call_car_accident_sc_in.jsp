<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*,  acar.common.*" %>
<%@ page import="acar.call.*" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	PollDatabase p_db = PollDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");	
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	Vector vt = p_db.getCarAccidentCallAll(dt, ref_dt1, ref_dt2, gubun2, sort, s_kd, t_wd);
		
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

function upd_call( m_id, l_cd, c_id, accid_id, accid_st)
{
	var theForm = document.CarRegDispForm;
										
	if(confirm('대표통화완료처리 하시겠습니까?') )
	{		
		theForm.target = 'i_no';
		theForm.action = "updateReqAccidentCall_a.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&accid_st="+accid_st ;
		theForm.submit();
	}
}
	
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="1380">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1380">
            	<tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;' width=15%> 
                        <table border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td width=20% class=title >연번</td>
                                <td width=30% class=title   style='height:30'>대표</td> 
                                <td width=50% class=title>계약번호</td>
                            </tr>
                        </table>
                    </td>
		  <td class=line width=85%>
			        	<table  border=0 cellspacing=1 width="100%">
                          <tr> 
                          	            <td width=90 class=title  style='height:30'>콜등록일</td>
                         	            <td width=90 class=title>사고일</td>
	                            <td width=70 class=title>사고유형</td>                                                   
	                            <td width=130 class=title>상호</td>
	                            <td width=80 class=title>차량번호</td>
	                            <td width=150 class=title>차종</td>
	                            <td width=140 class=title>사고장소</td>	
	                             <td width=180 class=title>사고내용</td>	
	                            <td width=60 class=title>접수자</td>	
	                            <td width=80 class=title>등록자</td>	
	                         			
                          </tr>
                        </table>
			        </td>
				</tr>
<%	if(vt_size > 0){%>
            	<tr>            		
                    <td class=line id='D1_col' style='position:relative;' width=15%> 
                        <table border=0 cellspacing=1 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                          <tr> 
                            <td align="center" width=20%><%= i+1%></td>
                            <td align="center" width=30%>
                          <%if(String.valueOf(ht.get("R_ANSWER")).equals("Y")){%>통화 
                         <%     if(String.valueOf(ht.get("RR_ANSWER")).equals("Y")){%>완료  
                          <%    }else{%> 
		                 <a href="javascript:upd_call('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>')" title='대표통화처리'><%=ht.get("RR_ANSWER")%></a>   
		        <%}%>                                                 
                            <% } %>
                         </td>
                            <td align="center" width=50%><a href="javascript:parent.AccidentDisp('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("ACCID_ID")%>', '<%=ht.get("ACCID_ST")%>')">&nbsp;<%=ht.get("RENT_L_CD")%></a></td>
                          </tr>
              <%}%>
                        </table>
                   </td>            		            		
            	 <td class=line width=85%>
            			<table border=0 cellspacing=1 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                          <tr> 
                            <td width=90 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ANSWER_DATE")))%></td>
                            <td width=90 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%></td>
                            <td width=70 align="center"><%=ht.get("ACCID_ST_NM")%></td>
                            <td width=130 align="center"><span title="<%= ht.get("FIRM_NM") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>
                             <td width=80 align="center"><%= ht.get("CAR_NO")%></td>   
                             <td width=150 align="left"><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),14) %></span></td>
                             <td width=140 align="left"><span title='<%=ht.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(ht.get("ACCID_ADDR")), 10)%></span></td> 
	                   <td width=180 align="left"><span title='<%=ht.get("ACCID_CONT")%> <%=ht.get("ACCID_CONT2")%>'><%=Util.subData(String.valueOf(ht.get("ACCID_CONT"))+" "+String.valueOf(ht.get("ACCID_CONT2")), 14)%></span></td> 
                            <td width=60 align="center"><%=c_db.getNameById(String.valueOf(ht.get("ACC_ID")), "USER")%></td>
                            <td width=80 align="center"><%=Util.subData(c_db.getNameById(String.valueOf(ht.get("CREG_ID")), "USER"),6)%></td>
                          </tr>
              <%}%>
                        </table>
		   </td>            		            		
            	</tr>
<%}%>
<%	if(vt_size == 0){%>
	            <tr>
            		
                    <td class=line id='D1_col' width=15% style='position:relative;'> 
                        <table border=0 cellspacing=1 width=100%>
                          <tr> 
                            <td align="center"></td>
                          </tr>
                        </table>
                    </td>            		            		
            		<td class=line width=85%>
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
<input type="hidden" name="accid_id" value="">
<input type="hidden" name="accid_st" value="">
<input type="hidden" name="p_gubun" value="">

<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='g_fm' value="1">
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</form>
</body>
</html>