<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	if (request.getParameter("fromSearch") != null && !(((String) request.getParameter("fromSearch")).equals("true"))) {
		return;
	}

	String auth_rw = "";
	String gubun_nm = "";
	String gubun = "";
	String ref_dt1 = "";
	String ref_dt2 = "";

	if(request.getParameter("auth_rw") != null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null) gubun = request.getParameter("gubun");

	String sort 	= request.getParameter("sort") == null ? "2" : request.getParameter("sort");
	String car_ck 	= request.getParameter("car_ck") == null ? "" : request.getParameter("car_ck");
	String gubun2 	= request.getParameter("gubun2") == null ? "" : request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3") == null ? "" : request.getParameter("gubun3");

	if(request.getParameter("gubun_nm") != null) {
		gubun_nm = java.net.URLDecoder.decode((String) request.getParameter("gubun_nm"), "utf-8");
	}

	Vector vt = ad_db.getServAllNew3(gubun, gubun_nm, gubun3, gubun2, sort, car_ck, 1, 100);

	int vt_size = vt.size();

	long t_d1[] = new long[1];
	long t_d2[] = new long[1];
	
	float a_dis= 0;
 	long  l_a_dis = 0;
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
var currentPage = 1;
var rowsPerpage = 100;

var lastScrollTop = 0;

var isLoading = false;

function isBottom() {
	var bottomY = document.body.clientHeight  + document.body.scrollTop;
	var currentY = document.body.scrollHeight;

	var st = document.body.scrollTop;

	if (st > lastScrollTop){
		if (bottomY >= currentY * 0.98) {
			return true;
		}
	}

	lastScrollTop = st;

	return false;
}

function addListener(target, type, handler) {
	if (target.addEventListener) {
		target.addEventListener(type, handler, false);
	} else if (target.attachEvent) {
		target.attachEvent("on" + type, handler);    
	} else {
		target["on" + type] = handler;
	}
}

addListener(window, "scroll" , function(e) {
	if (isLoading) {
		return;
	}

	if (isBottom()) {
		isLoading = true;

		currentPage++;

		loadXMLDoc(currentPage, rowsPerpage);
	}
});

function loadXMLDoc(selectedPage, rowsPerPage) {
    var xmlhttp;

    if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
    } else {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    var DONE = 4;
	var VALID = 200;

	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == DONE) {
			if(xmlhttp.status == VALID) {
				var appendHTML = xmlhttp.responseText;

				appendHTML = appendHTML.replace(/\r\n/gi,'');
				appendHTML = appendHTML.replace(/\t/gi,'');
				appendHTML = appendHTML.replace(/ /gi,'');
				appendHTML = appendHTML.replace(/^\s+|\s+$/gm,'');

				if (appendHTML == 'EOR') {
					return;
				}

				appendRows(xmlhttp.responseText);
			} else {
				alert('error');
			}

			setTimeout(openScroll, 500);
		}
	}

    xmlhttp.open("POST", "./car_s_sc_in_ajax.jsp", true);

    xmlhttp.timeout = 30000;

	xmlhttp.ontimeout = function() {
		setTimeout(openScroll, 500);

		console.log("timeout");
	}

	var g_nm = '<%= gubun_nm %>';

    var params = "gubun_nm=" + encodeURIComponent(encodeURIComponent(g_nm))
			   + "&gubun=<%= gubun %>"
			   + "&gubun3=<%= gubun3 %>"
			   + "&gubun2=<%= gubun2 %>"
			   + "&sort=<%= sort %>"
			   + "&car_ck=<%= car_ck %>"
			   + "&selectedPage=" + selectedPage
			   + "&rowsPerPage=" + rowsPerPage;

    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
    xmlhttp.setRequestHeader("Content-length", params.length);
    xmlhttp.setRequestHeader("Connection", "close");

    xmlhttp.send(params);
}

function openScroll() {
	isLoading = false;	
}

function appendRows(rows) {
	var table = document.getElementById('mainTable').getElementsByTagName('tbody')[0];

	var tmpTable = document.createElement('div');

	tmpTable.innerHTML = '<table><tbody>' + rows + '</tbody></table>';

	var tr = tmpTable.getElementsByTagName('tr')[0].cloneNode(true);

	table.appendChild(tr);
}

function AccidentDisp(car_mng_id, accid_id)
{
	var theForm = document.AccidDispForm;
	theForm.car_mng_id.value = car_mng_id;
	theForm.accid_id.value = accid_id;
	theForm.target = "d_content";
	theForm.submit();
}

function ServiceList(car_mng_id, rent_mng_id, rent_l_cd, serv_dt)
{
	
	var url	= "?car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&serv_dt="+serv_dt;
	var SUBWIN="./serv_daily_c.jsp"+ url;
	window.open(SUBWIN, "ServiceList", "left=100, top=100, width=800, height=330, scrollbars=yes");
}

	
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id="+car_id+"&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	
	
	function req_fee_start_act(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=ck_acar_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=620, height=470");
	}

	
function view_car_dist(m_id, l_cd, c_id){
		window.open("/fms2/car_reg/car_dist_reg.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id, "VIEW_CAR_DIST", "left=100, top=100, width=400, height=200, scrollbars=no");		
}


	
/* Title */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}


function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft;

    // ¡§??¡?­script error￠®￠´??¡§?¡?//    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft;
}

function init() {
	setupEvents();
}

//-->
</script>
</head>
<body onload="javascript:init();">
<table border=0 cellspacing=0 cellpadding=0 width="1085">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%" id="mainTable">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
            	<tr id='title' style='position:relative;z-index:1'>
            		<td class=line id='title_col0' style='position:relative;' width=475>
            			<table border=0 cellspacing=1 width="100%" cellpadding=0>
	            			<tr>
								<td width='40' class='title' style='height:38'>연번</td> 
								<td width='100' class='title'>계약번호</td>
								<td width='75' class='title'>계약일</td>
								<td width='120' class='title'>상호</td>
								<td width='70' class='title'>현재<br>주행거리</td>
								<td width='70' class='title'>연평균<br>주행거리</td>						            				
								
							</tr>
			            </table>
			        </td>
			        <td class=line width=610>
			        	<table  border=0 cellspacing=1 cellpadding=0 width="100%">
			        		<tr>
								<td width='70' class='title'>관리담당자</td>
								<td width='90' class='title'>차량번호</td>							
								<td width='150' class='title'>차종</td>
								<td width='75' class='title' style='height:38'>최초<br>등록일</td>													
								<td width='75' class='title'>개시일</td>
								<td width='75' class='title'>관리구분</td>
								<td width='75' class='title'>정비일</td>
							</tr>
			            </table>
			        </td>
				</tr>
				

<%
	if(vt_size > 0)
	{
%>
				<tr>
					<td class='line' width='475' id='D1_col' style='position:relative;'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			a_dis =   AddUtil.parseFloat(String.valueOf(ht.get("SS")));
			l_a_dis = (long) a_dis;
%>
							<tr>
								<td  width='40' align='center'><%=i+1%></td>
								<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
								<td  width='75' align='center'><%=ht.get("RENT_DT")%></td>
								<td  width='120'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
								<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>
								<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("Y_AVE_DIST")))%>
								<span class="b"><a href="javascript:view_car_service('<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title="정비기록표"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0"></a></span>
								</td>

							</tr>
<%
		}
%>
						</table>
					</td>
					<td class='line' width='610'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
							<tr>
								<td  width='70' align='center'>
									<a href="javascript:req_fee_start_act('주행거리 입력착오 수정바람','<%=ht.get("CAR_NO")%> 현재주행거리 <%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%>km,  연환산주행거리 <%=AddUtil.parseDecimal(String.valueOf(ht.get("Y_AVE_DIST")))%>km -> 주행거리 입력 확인 필요', '<%=ht.get("MNG_ID")%>')" onMouseOver="window.status=''; return true" title='관리담당자에게 주행거리 확인 요청하기'>			
										<%=ht.get("MNG_NM")%>
									</a> 
								</td>
								<td  width='90' align='center'><a href="javascript:view_car_dist('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title="<%=ht.get("CAR_MNG_ID")%>"><span title='<%=ht.get("CAR_MNG_ID")%>'><%=ht.get("CAR_NO")%></span></a></td>							
								<td  width='150'>&nbsp;<%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 10)%></td>					
								<td  width='75' align='center'><%=ht.get("INIT_REG_DT")%></td>								
								<td  width='75' align='center'><%=ht.get("RENT_START_DT")%></td>
								<td  width='75' align='center'><%=ht.get("RENT_WAY_NM")%></td>
								<td  width='75' align='center'><span title='<%=ht.get("DDTT")%>'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TOT_DT")))%></span></td>													
							</tr>
<%
		}
%>
						</table>
					</td>
				</tr>
<%	}
	else
	{
%>                     
					<tr>
						<td class='line' width='475' id='D1_col' style='position:relative;'>
							<table border="0" cellspacing="1" cellpadding="0" width=100%>
								<tr>
									<td align='center'>
									<%if(gubun_nm.equals("")){%> 
									
									<%}else{%>
									
									<%}%>
									</td>
								</tr>
							</table>
						</td>
						<td class='line' width='610'>
							<table border="0" cellspacing="1" cellpadding="0" width=100%>
								<tr>
									<td>&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
<%                     
	}                  
%>
            </table>
        </td>
    </tr>
</table>

</body>
</html>