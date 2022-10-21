<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.cus_pre.*, acar.user_mng.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	Hashtable id = c_db.getDamdang_id(user_nm);
	user_id = String.valueOf(id.get("USER_ID"));		
	
	//기본식 담당자 자동 배정리스트
	Vector vt = ad_db.getContBusCngHListNew(user_id);
	int vt_size = vt.size();
	
	
	//로그인ID&영업소ID&권한
	String acar_id = ck_acar_id;
%>
<%	%>
<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	//영업담당자 변경
	function cng_bus(m_id, l_cd, fee_rent_st){
//		window.open("/acar/car_rent/cng_bus.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=cus", "CNG_BUS", "left=100, top=10, width=400, height=220, scrollbars=yes, status=yes");
		window.open("/fms2/lc_rent/cng_item.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&rent_st="+fee_rent_st+"&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&cng_item=bus_id2&from_page=/acar/cus_pre/cus_pre_sc_cng.jsp", "CNG_BUS", "left=100, top=10, width=1050, height=600, scrollbars=yes, status=yes");
	}
	//새로고침
	function CusPreCtRelode(){
		var fm = document.form1;
		fm.action = 'cus_pre_sc_cng.jsp';		
		fm.submit();					
	}	
//-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><a name='9'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업담당자 배정 리스트 : 최근2개월이내</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%" class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td width=3% rowspan="2" align="center" class='title'>연번</td>
                    <td width=12% rowspan="2" align="center" class='title'>계약번호</td>
                    <td width=13% rowspan="2" align="center" class='title'>상호</td>
                    <td width=12% rowspan="2" align="center" class='title'>차량번호</td>
                    <td width=12% rowspan="2" align="center" class='title'>차명</td>
                    <td width=9% rowspan="2" align="center" class='title'>대여개시일</td>
                    <td width=8% rowspan="2" align="center" class='title'>대여구분</td>					
                    <td colspan="2" align="center" class='title'>배정</td>
                    <td width=9% rowspan="2" align="center" class='title'>변경일자</td>
                    <td width=8% rowspan="2" align="center" class='title'>현재담당자</td>
                </tr>
                <tr align="center">
                    <td width=7% class='title'>변경전</td>
                    <td width=7% class='title'>변경후</td>
                </tr>
          <%//기본식 채권이관 이력 조회
			if(vt_size > 0){
				for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("RENT_L_CD")%></td>
                    <td align="center"><%=ht.get("FIRM_NM")%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    <td align="center"><%=ht.get("RENT_START_DT")%></td>
                    <td align="center"><%=ht.get("RENT_WAY")%></td>					
                    <td align="center"><%=c_db.getNameById(String.valueOf(ht.get("OLD_VALUE")), "USER")%></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(ht.get("NEW_VALUE")), "USER")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%></td>
                    <td align="center">
        			<%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("부산지점장",ck_acar_id) || nm_db.getWorkAuthUser("대전지점장",ck_acar_id)  || nm_db.getWorkAuthUser("본사관리팀장",ck_acar_id)   ){%>
        			<a href="javascript:cng_bus('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("FEE_RENT_ST")%>')"><%=c_db.getNameById(String.valueOf(ht.get("BUS_ID2")), "USER")%></a>
        			<%}else{%>
        			<%=c_db.getNameById(String.valueOf(ht.get("BUS_ID2")), "USER")%>
        			<%}%>
        			</td>
                </tr>
          <%  }
			}else{%>
                <tr>
                    <td colspan="11" align="center">자료가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>		
    <tr> 
        <td>※ 자동배정 조건 : 대여개시일로부터 6개월 경과, 6회차 대여료까지 입금완료, 미수과태료 및 미수면책금 없어야함.(대전지점 제외)</td>
    </tr>	
</table>
</form>
</body>
</html>

