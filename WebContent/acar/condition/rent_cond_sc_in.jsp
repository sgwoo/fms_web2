<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*, acar.common.*" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	Vector vt = cdb.getRentCondAll_20071025(dt, ref_dt1, ref_dt2, gubun2, gubun3, gubun4, sort);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<% 
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
		//theForm.action = "./register_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}else{
%>
		if(reg_gubun=="id")
		{
			alert("미등록 상태입니다.");
			return;
		}
		//theForm.action = "./register_r_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}
%>
	theForm.target = "d_content"
	theForm.submit();
}
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

function view_client(rent_mng_id, rent_l_cd, r_st)
{
	var SUBWIN="/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;	
	window.open(SUBWIN, "View_CLIENT", "left=50, top=50, width=680, height=700, resizable=yes");
}

//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="1800">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1800">
            	<tr id='title' style='position:relative;z-index:1'>            		
                    <td class=line id='title_col0' style='position:relative;'> 
		                <table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td width=35% class=title >연번</td>
                                <td width=65% class=title>계약번호</td>
                            </tr>
                        </table>
                    </td>
			        <td class=line>
			        	<table  border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td width=5% class=title>계약일</td>
                                <td width=5% class=title>대여개시일</td>
                                <td width=8% class=title>상호</td>
                                <td width=5% class=title>계약자</td>
                                <td width=10% class=title>차종</td>
                                <td width=5% class=title>출고일</td>
                                <td width=5% class=title>등록일</td>
                                <td width=6% class=title>할부금융사</td>
                                <td width=5% class=title>보험사</td>				
                				<td width=4% class=title>기간</td>
                                <td width=5% class=title>계약구분</td>
                                <td width=6% class=title>영업구분</td>
                                <td width=5% class=title>차량구분</td>				
                                <td width=5% class=title>용도구분</td>
                                <td width=5% class=title>관리구분</td>
                                <td width=4% class=title>영업사원</td>
                                <td width=4% class=title>최초영업</td>
                                <td width=4% class=title>영업담당</td>
                                <td width=4% class=title>관리담당</td>								
                            </tr>
                        </table>
		            </td>
	            </tr>
<%	if(vt_size > 0){%>
            	<tr>
            		
                    <td class=line id='D1_col' style='position:relative;'> 
                        <table border=0 cellspacing=1 width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                            <tr> 
                                <td align="center" width=35%><%= i+1%></td>
                                <td align="center" width=65%><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("RENT_L_CD")%></a></td>
                            </tr>
                          <%}%>
                        </table>
                    </td>            		            		
                    <td class=line>
                        <table border=0 cellspacing=1 width=100%>
                          <% for (int i = 0 ; i < vt_size ; i++){
            					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                            <tr> 
                                <td width=5% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                                <td width=5% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                                <td width=8% align="left">&nbsp;<span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></a></span></td>
                                <td width=5% align="center"><span title="<%=ht.get("CLIENT_NM")%>"><%=Util.subData(String.valueOf(ht.get("CLIENT_NM")), 4)%></a></span></td>
                                <td width=10% align="left"><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),11) %></span></td>
                                <td width=5% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
                                <td width=5% align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                                <td width=6% align="center"><%=ht.get("CPT_NM")%></td>
                								<td width=5% align="center">
                									<%String bhs_str =c_db.getNameById(String.valueOf(ht.get("INS_COM_ID")),"INS_COM");%>
                										<span title="<%=c_db.getNameById(String.valueOf(ht.get("INS_COM_ID")),"INS_COM")%>"><%if(bhs_str.length()>=5){%><%=bhs_str.substring(0,4)+".."%><%}else{%><%=c_db.getNameById(String.valueOf(ht.get("INS_COM_ID")),"INS_COM")%><%}%>
                								</td>				
                                <td width=4% align="center"><%=ht.get("CON_MON")%></td>
                                <td width=5% align="center"><%if(String.valueOf(ht.get("EXT_ST")).equals("")){%><%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%></td>
                                <td width=6% align="center"><%=ht.get("BUS_ST")%></td>				
                                <td width=5% align="center"><%=ht.get("CAR_GU")%></td>				
                                <td width=5% align="center"><%=ht.get("CAR_ST")%></td>								
                                <td width=5% align="center"><%=ht.get("RENT_WAY")%></td>								
                                <td width=4% align="center"><span title="<%=ht.get("EMP_NM")%>"><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 3)%></a></span></td>
                                <td width=4% align="center"><%=ht.get("BUS_NM")%></td>
                                <td width=4% align="center"><%=ht.get("BUS_NM2")%></td>
                                <td width=4% align="center"><%=ht.get("MNG_NM")%></td>								
                            </tr>
                            <%}%>
                        </table>
            	    </td>            		            		
                </tr>
            <%}%>
            <%	if(vt_size == 0){%>
                <tr>            		
                    <td class=line id='D1_col' style='position:relative;'> 
            		    <table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td align="center"></td>
                            </tr>
                        </table>
                    </td>            		            		
                    <td class=line>
                        <table border=0 cellspacing=1 width=100%>
            		        <tr>
            		            <td>&nbsp;등록된 데이타가 없습니다.</td>
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