<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.client.*, acar.car_register.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");

String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "01", "07", "15");
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//출고정보
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());

	//디지탈키정보
	Hashtable key = ec_db.getDigitalKey(m_id, l_cd);
	
	//디지탈키정보
	Hashtable tech = ec_db.getTempHighTech(cr_bean.getCar_mng_id(), cr_bean.getCar_no());
	
	//기본사양 포함 차명
	String car_b_inc_name = cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
	.highlight {
	font-size:20px;
	font-weight:bold;
	color:#fff;
	background: #4F56E5;
	border-radius:2px;	
	}
</style>
<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//해당 차량 상위차종 기본사양 보기
	function open_car_b(car_id, car_seq, car_name){
		fm = document.form1;
		window.open('/fms2/lc_rent/view_car_b.jsp?from_page=digital_key&car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=450, height=600, scrollbars=yes"); 
	}	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>       
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='m_id' 	value='<%=m_id%>'>
  <input type='hidden' name='l_cd' 	value='<%=l_cd%>'>
  <input type='hidden' name='mode' 	value='<%=mode%>'>
  <input type='hidden' name='firm_nm' 	value='<%=client.getFirm_nm()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>디지탈키2 관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='29%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>대여기간</td>
                    <td width='41%'>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(base.getRent_end_dt())%></td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td colspan='3'>&nbsp;<%=client.getFirm_nm()%><%if(!client.getClient_st().equals("2")){%>&nbsp;<%=client.getClient_nm()%><%}%></td>
                </tr>                     
                <tr> 
                    <td class='title'>고객구분</td>
                    <td>&nbsp;<%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");
        				else if(client.getClient_st().equals("6")) 	out.println("경매장");%></td>
                    <td class='title'>사업자번호</td>
                    <td>&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></td>
                </tr>                
            </table>
    	</td>
    </tr>
    <%if(!site.getR_site().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>            
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>        
                <tr> 
                    <td class='title' width='15%'><%if(site.getSite_st().equals("1")) 		out.println("지점");
                      	else if(site.getSite_st().equals("2"))  out.println("현장");%></td>
                    <td width='29%'>&nbsp;<%=site.getR_site()%></td>
                    <td class='title' width='15%'>사업자번호</td>
                    <td width='41%'>&nbsp;<%=AddUtil.ChangeEnp(site.getEnp_no())%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%}%>
    <tr>
        <td class=h></td>
    </tr>            
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>        
                <tr> 
                    <td class='title' width='15%'>차량번호</td>
                    <td width='29%'>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title' width='15%'>차대번호</td>
                    <td width='41%'>&nbsp;<%=cr_bean.getCar_num()%></td>
                </tr>
                <tr> 
                    <td class='title'>차명</td>
                    <td colspan='3'>&nbsp;<%=cr_bean.getCar_nm()%> <%=cm_bean.getCar_name()%></td>
                </tr>                
                <tr> 
                    <td class='title'>기본사양</td>
                    <td colspan='3'>&nbsp;
                    <% if(!car_b_inc_name.equals("")){ %> <a href="javascript:open_car_b('<%= cm_bean.getCar_b_inc_id() %>','<%= cm_bean.getCar_b_inc_seq() %>','<%= car_b_inc_name %>');"  onMouseOver="window.status=''; return true"><%= car_b_inc_name %> 기본사양</a> 외 <br>&nbsp;<% } %>
                    <dlv id="contents1"><%=tech.get("CAR_B")%></dlv></td>
                </tr>     
                <tr> 
                    <td class='title'>선택사양</td>
                    <td colspan='3'>&nbsp;<dlv id="contents2"><%=tech.get("CAR_S")%></dlv></td>
                </tr>                 
                <tr> 
                    <td class='title'>선택사양 비고</td>
                    <td colspan='3'>&nbsp;<dlv id="contents3"><%=tech.get("OPT_B")%></dlv></td>
                </tr>
            </table>
        </td>
    </tr>        
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td align="right">	
		  <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>    
</table>
</form>
<script language="JavaScript">
<!--	
var search = '디지털';
$("#contents1:contains('"+search+"')").each(function (){
	var regex = new RegExp(search, 'gi');
	$(this).html( $(this).text().replace(regex, "<span class='highlight'>"+search+"</span>"));
})
$("#contents2:contains('"+search+"')").each(function (){
	var regex = new RegExp(search, 'gi');
	$(this).html( $(this).text().replace(regex, "<span class='highlight'>"+search+"</span>"));
})
$("#contents3:contains('"+search+"')").each(function (){
	var regex = new RegExp(search, 'gi');
	$(this).html( $(this).text().replace(regex, "<span class='highlight'>"+search+"</span>"));
});
//-->
</script>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
