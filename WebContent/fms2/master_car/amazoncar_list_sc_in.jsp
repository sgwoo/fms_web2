<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_register.*, acar.master_car.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");

	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_no 			= request.getParameter("car_no")==null?"":request.getParameter("car_no");

	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll_mc(car_mng_id);
	
	Vector vt = mc_db.amazoncar_list(br_id, st, ref_dt1, ref_dt2, gubun, gubun_nm, gubun3, q_sort_nm, q_sort);
	int vt_size = vt.size();
	
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
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
	//등록하기
	function Reg(){
		fm = document.form1;
//		if(fm.car_mng_id.value==''){	alert("상단을 먼저 등록해주세요!"); return; }
//		fm.target = "c_foot";
		fm.action = "master_register_his_id_ins.jsp";
		fm.submit();
	}

//스캔한 등록증 보기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL;
		window.open(theURL,winName,features);
	}

	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg' || file_type == '.JPG'){
			window.open('/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL,'popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
	}		
	
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=650, scrollbars=yes");		
	}
	
		//스캔관리 보기 - 협력업체 자동차등록증만
	function openP(c_id){
		window.open("view_scan.jsp?c_id="+c_id, "VIEW_SCAN", "left=100, top=100, width=720, height=350, scrollbars=yes");		
	}
//-->
</script>
</head>
<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">

<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="cha_seq" value="">
<input type="hidden" name="scanfile_nm" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
                <table border=0 cellspacing=1 cellpadding=0 width=100%>
                            <tr> 
                                <td width=7% class=title>연번</td>
                                <td width=10% class=title>차량번호</td>
                                <td class=title>차명</td>
                		    <td width=8% class=title>등록일</td>
                		    <td width=14% class=title>연료</td>
                                <td width=8% class=title>차령만료일</td>
                                <td width=7% class=title>용도</td>
                                <td width=7% class=title>지역</td>
                                <td width=7% class=title>관리담당자</td>
                                <td width=10% class=title>연락처</td>  
                                <td width=10% class=title>등록증</td>

                            </tr>
<%	if(vt_size > 0){%>
            <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				%>                    				
                            <tr> 
                                <td width=7% align="center"><%=i+1%></td>
                                <td width=10% align="center">
								<%if(user_id.equals("000155")||user_id.equals("000096")){%>
								<a href="javascript:view_scan('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_NO")%></a>
								<%}else{%>
								<%=ht.get("CAR_NO")%>
								<%}%>
								</td>
                                <td align="left">&nbsp;<%=ht.get("CAR_NM")%></td>
                                <td width=8% align="center"><%=ht.get("INIT_REG_DT")%></td>				
                                <td width=14% align="center"><%=ht.get("FUEL_KD")%></td>
                                <td width=8% align="center"><%=AddUtil.ChangeDate2(AddUtil.toString(ht.get("CAR_END_DT")))%></td>
                                <td width=7% align="center"><%=ht.get("CAR_USE")%></td>
                                <td width=7% align="center"><%=ht.get("CAR_EXT")%></td>
                                <td width=7% align="center"><%=ht.get("MNG_NM")%></td>
                                <td width=10% align="center"><%=ht.get("MNG_NM_HP")%></td>
                                <td width=10% align="center">
								<a href="javascript:openP('<%=ht.get("CAR_MNG_ID")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>    					
	
								
<input type="hidden" name="rent_mng_id" value="<%=ht.get("RENT_MNG_ID")%>">
<input type="hidden" name="rent_l_cd" value="<%=ht.get("RENT_L_CD")%>">
<input type="hidden" name="car_mng_id" value="<%=ht.get("CAR_MNG_ID")%>">
<input type="hidden" name="car_no" value="<%=ht.get("CAR_NO")%>">	
<%if(user_id.equals("000140")){%>
			    	<a href="javascript:Reg();"><img src="/acar/images/center/button_in_reg.gif" align="absmiddle" border="0"></a>     	</td>
<%}%>
                            </tr>
                          <%	}%>
                          <%}%>			  
            			  <%	if(vt_size == 0){%>
                            <tr> 
                                <td colspan="12" align="center">&nbsp;등록된 데이타가 없습니다.</td>
                            </tr>
            			  <%}%>			  
            </table>
        </td>
    </tr>
</table>

</form>

</body>
</html>