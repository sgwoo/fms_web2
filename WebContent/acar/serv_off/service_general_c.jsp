<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_service.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>

<%
	CarServDatabase csd = CarServDatabase.getInstance();
	ServOffDatabase sod = ServOffDatabase.getInstance();

	int count = 0;
	String auth_rw = "";
	String rent_mng_id = "";
	String rent_l_cd = "";
	String car_mng_id = "";
	String car_no = "";
	String off_id = "";
	String firm_nm = "";
	String client_nm = "";
	String serv_id = "";
	
	/* 서비스 정보 */
	String accid_id = ""; 
	String serv_dt = ""; 
	String serv_st = "";
	String serv_st_nm = ""; 
	String checker = ""; 
	String tot_dist = ""; 
	String rep_nm = ""; 
	String rep_tel = ""; 
	String rep_m_tel = ""; 
	int rep_amt = 0; 
	int sup_amt = 0; 
	int add_amt = 0; 
	int dc = 0; 
	int tot_amt = 0; 
	String sup_dt = ""; 
	String set_dt = ""; 
	String serv_bank = ""; 
	String serv_acc_no = ""; 
	String serv_acc_nm = ""; 
	String rep_item = ""; 
	String rep_cont = ""; 
	String cust_plan_dt = ""; 
	int cust_amt = 0; 
	String cust_agnt = "";
	
	String off_nm = ""; 
	String off_st = ""; 
	String own_nm = ""; 
	String ent_no = ""; 
	String off_sta = ""; 
	String off_item = ""; 
	String off_tel = ""; 
	String off_fax = ""; 
	String homepage = ""; 
	String off_post = ""; 
	String off_addr = ""; 
	String bank = ""; 
	String acc_no = ""; 
	String acc_nm = ""; 
	String note = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("rent_mng_id") !=null) rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") !=null) rent_l_cd = request.getParameter("rent_l_cd");
	if(request.getParameter("car_mng_id") !=null) car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("car_no") !=null) car_no = request.getParameter("car_no");
	if(request.getParameter("off_id") !=null) off_id = request.getParameter("off_id");
	if(request.getParameter("firm_nm") !=null) firm_nm = request.getParameter("firm_nm");
	if(request.getParameter("client_nm") !=null) client_nm = request.getParameter("client_nm");
	if(request.getParameter("serv_id") !=null) serv_id = request.getParameter("serv_id");
	
	if(!off_id.equals(""))
	{
		so_bean = sod.getServOff(off_id);
		
		off_nm = so_bean.getOff_nm(); 
		off_st = so_bean.getOff_st(); 
		own_nm = so_bean.getOwn_nm(); 
		ent_no = so_bean.getEnt_no(); 
		off_sta = so_bean.getOff_sta(); 
		off_item = so_bean.getOff_item(); 
		off_tel = so_bean.getOff_tel(); 
		off_fax = so_bean.getOff_fax(); 
		homepage = so_bean.getHomepage(); 
		off_post = so_bean.getOff_post(); 
		off_addr = so_bean.getOff_addr(); 
		bank = so_bean.getBank(); 
		acc_no = so_bean.getAcc_no(); 
		acc_nm = so_bean.getAcc_nm(); 
		note = so_bean.getNote();
	}
	
	s_bean = csd.getService(car_mng_id,serv_id);
	accid_id = s_bean.getAccid_id();
	serv_dt = s_bean.getServ_dt();
	serv_st = s_bean.getServ_st();
	serv_st_nm = s_bean.getServ_st_nm();
	checker = s_bean.getChecker();
	tot_dist = s_bean.getTot_dist();
	rep_nm = s_bean.getRep_nm();
	rep_tel = s_bean.getRep_tel();
	rep_m_tel = s_bean.getRep_m_tel();
	rep_amt = s_bean.getRep_amt();
	sup_amt = s_bean.getSup_amt();
	add_amt = s_bean.getAdd_amt();
	dc = s_bean.getDc();
	tot_amt = s_bean.getTot_amt();
	sup_dt = s_bean.getSup_dt();
	set_dt = s_bean.getSet_dt();
	serv_bank = s_bean.getBank();
	serv_acc_no = s_bean.getAcc_no();
	serv_acc_nm = s_bean.getAcc_nm();
	rep_item = s_bean.getRep_item();
	rep_cont = s_bean.getRep_cont();
	cust_plan_dt = s_bean.getCust_plan_dt();
	cust_amt = s_bean.getCust_amt();
	cust_agnt = s_bean.getCust_agnt();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function RoundServReg()
{
	var theForm = document.RoundServRegForm;
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.submit();
}
function RoundServUp()
{
	var theForm = document.RoundServRegForm;
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	theForm.target = "i_no";
	theForm.submit();
}
function ServItemAdd()
{
	var theForm = document.ServItemRegForm;
	if(theForm.serv_id.value=="")
	{
		alert("등록 후 추가하십시요.");
		return;
	}
	if(!confirm("품명을 추가하시겠습니까?"))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.submit();
}
function LoadServItem(serv_id)
{
	var theForm = ServItemList.document.LoadServItemFrom;
	theForm.serv_id.value = serv_id;
	theForm.submit();
}
function LoadServiceReg()
{
	opener.parent.LoadService();
	self.close();
	window.close();
}
function GenerServUp()
{
	var theForm = document.GenerServUpDispForm;
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin="15">

<table border=0 cellspacing=0 cellpadding=0 width="700">
<form action="./service_general_ui.jsp" name="GenerServUpDispForm" method="POST" >
    <tr>
    	<td ><font color="navy">차량관리 -> 정비/점검 이력관리</font><font color="red">일반수리</font></td>
    </tr>
    <tr>
    	<td align="right">
<%
	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
    	<a href="javascript:GenerServUp()">수정화면</a>&nbsp;|&nbsp;
<%
	}
%>
    	<a href="javascript:LoadServiceReg();">닫기</a>    	</td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width="700">
                <tr>
                    <td width="70" class=title>계약번호</td>
                    <td width="105" align="center"><%=rent_l_cd%><input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>"><input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>" size="15" class=text></td>
                    <td width="70" class=title>차량번호</td>
                    <td width="105" align="center"><%=car_no%><input type="hidden" name="car_mng_id" value="<%=car_mng_id%>"><input type="hidden" name="car_no" value="<%=car_no%>" size="15" class=text></td>
                    <td width="70" class=title>상호</td>
                    <td width="125" align="center"><span title="<%=firm_nm%>"><%=Util.subData(firm_nm,8)%></span><input type="hidden" name="firm_nm" value="<%=firm_nm%>" size="15" class=text></td>
                    <td width="70" class=title>계약자</td>
                    <td width="85" align="center"><%=client_nm%><input type="hidden" name="client_nm" value="<%=client_nm%>" size="15" class=text></td>
                </tr>
                
            </table>
        </td>
    </tr>
    <tr>
    	<td align="right">
    		<input type="hidden" name="accid_id" value="GGGGGG">
    		<input type="hidden" name="serv_id" value="<%=serv_id%>">
    		<input type="hidden" name="serv_st" value="2">
    		<input type="hidden" name="off_id" value="<%=off_id%>">
    		<input type="hidden" name="rep_nm" value="">
    		<input type="hidden" name="rep_item" value="">
    		<input type="hidden" name="cmd" value="">
    	</td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width="700">
                <tr>
                    <td class=title width=125>정비업체</td>
                    <td align="center" width=140><%=off_nm%></td>
                    <td class=title width=125>대표자</td>
                    <td align="center" width=140><%=own_nm%></td>
                    <td class=title width=125>사무실전화</td>
                    <td align="center" width=140><%=off_tel%></td>
                </tr>
                <tr>
                	<td class=title>전화2</td>
                    <td align="center"><%=rep_tel%><input type="hidden" name="rep_tel" value="<%=rep_tel%>" size="10" class=text></td>
                    <td class=title>팩스</td>
                    <td align="center"><%=off_tel%></td>
                    <td class=title>핸드폰</td>
                    <td align="center"><%=rep_m_tel%><input type="hidden" name="rep_m_tel" value="<%=rep_m_tel%>" size="10" class=text></td>
                </tr>
                <tr>
                    <td class=title>사업자번호</td>
                    <td align="center"><%=ent_no%></td>
                    <td class=title>주소</td>
                    <td align="left" colspan=3>&nbsp;(<%=off_post%>) <%=off_addr%></td>
                </tr>
                <tr>
                	<td class=title>정비비</td>
                    <td align="center"><%=rep_amt%><input type="hidden" name="rep_amt" value="<%=rep_amt%>" size="10" class=text></td>
                    <td class=title>공급가</td>
                    <td align="center"><%=sup_amt%><input type="hidden" name="sup_amt" value="" size="10" class=text></td>
                    <td class=title>부가세</td>
                    <td align="center"><%=add_amt%><input type="hidden" name="add_amt" value="" size="10" class=text></td>
                </tr>
                <tr>
                	<td class=title>DC</td>
                    <td align="center"><%=dc%><input type="hidden" name="dc" value="" size="10" class=text></td>
                    <td class=title>지급총액</td>
                    <td align="center"><%=tot_amt%><input type="hidden" name="tot_amt" value="" size="10" class=text></td>
                    <td class=title>지급일자</td>
                    <td align="center"><%=sup_dt%><input type="hidden" name="sup_dt" value="" size="10" class=text></td>
                </tr>
                <tr>
                	<td class=title>결제일</td>
                    <td align="center" colspan=5><%=set_dt%><input type="hidden" name="set_dt" value="" size="30" class=text></td>
                </tr>
                 <tr>
                	<td class=title>은행</td>
                    <td align="center"><%=serv_bank%><input type="hidden" name="bank" value="" size="10" class=text></td>
                    <td class=title>계좌번호</td>
                    <td align="center"><%=serv_acc_no%><input type="hidden" name="acc_no" value="" size="10" class=text></td>
                    <td class=title>예금주</td>
                    <td align="center"><%=serv_acc_nm%><input type="hidden" name="acc_nm" value="" size="10" class=text></td>
                </tr>
                 <tr>
                	<td class=title>점검내용</td>
                    <td align="center" colspan=5><textarea name="rep_cont" cols=95 rows=3></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td>자차면책금포함 : <input type="checkbox" name="" value=""></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width="700">
                <tr>
                    <td class=title>자차면책금</td>
                    <td align="center"><input type="hidden" name="" value="" size="10" class=text></td>
                    <td class=title>고객입금예정일</td>
                    <td align="center"><%=cust_plan_dt%><input type="hidden" name="cust_plan_dt" value="" size="10" class=text></td>
                    <td class=title>고객입금액</td>
                    <td align="center"><%=cust_amt%><input type="hidden" name="cust_amt" value="" size="10" class=text> km</td>
                </tr>
                
            </table>
        </td>
    </tr>
	</form>
	<form action="./service_item_null.jsp" name="ServItemRegForm" method="post">
    <tr>
    	<td>< 격적서 ></td>
    </tr>
    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=700>
				<tr>
					<td class='line' width="681">
						 <table  border=0 cellspacing=1 width="681">
			        		<tr>
			            		<td width=90 class=title>품명</td>
			            		<td width=91 class=title>규격</td>
			            		<td width=90 class=title>단위</td>
			            		<td width=90 class=title>수량</td>
			            		<td width=90 class=title>단가</td>
			            		<td width=90 class=title>공급가액</td>
			            		<td width=90 class=title>세액</td>
			            		<td width=50 class=title>&nbsp;</td>
			            	</tr>
			            	<tr>
			            		<td width=90 align=center><input type=text name="item" value="" size=5 class=text></td>
			            		<td width=91 align=center><input type=text name="std" value="" size=5 class=text></td>
			            		<td width=90 align=center><input type=text name="unit" value="" size=5 class=text></td>
			            		<td width=90 align=center><input type=text name="count" value="" size=5 class=text></td>
			            		<td width=90 align=center><input type=text name="price" value="" size=5 class=text></td>
			            		<td width=90 align=center><input type=text name="sup_amt" value="" size=5 class=text></td>
			            		<td width=90 align=center><input type=text name="tax" value="" size=5 class=text></td>
			            		<td width=50 align=center><a href="javascript:ServItemAdd()">추가</a></td>
			            	</tr>
			            </table>
					</td>
					<td width=19>&nbsp;
					<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
					<input type="hidden" name="serv_id" value="">
					<input type="hidden" name="cmd" value="">
					<input type="hidden" name="seq_no" value="">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</form>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=700>
				<tr>
					<td colspan=2><iframe src="./service_item_in.jsp?car_mng_id=<%=car_mng_id%>&serv_id=<%=serv_id%>" name="ServItemList" width="698" height="64" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>
</table>

<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

</body>
</html>