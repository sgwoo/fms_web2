<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.cont.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id		= ck_acar_id;
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//공통변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstimateBean [] e_r = e_db.getEstimateContList(rent_mng_id, rent_l_cd, "연장견적");
	int size = e_r.length;
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	int count = 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function EstiDoc(est_id){
		var SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=user_id%>&from_page=/fms2/lc_rent/lc_s_frame.jsp";	
		window.open(SUBWIN, "EstiDoc", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 
	}
	function estimates_view(rent_st, reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=<%=base.getCar_gu()%>&rent_st="+rent_st+"&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}		
//-->
</script>
</head>
<body>
<form action="esti_mng_u.jsp" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=1070>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>견적이력</span></span> : 견적이력</td>
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
        <td width=100% class='line' > 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=30 class=title>연번</td>
                    <td width=50 class=title>구분</td>			
                    <td width=100 class=title>견적번호</td>
                    <td width=100 class=title>대여상품</td>
                    <td width=60 class=title>대여<br>기간</td>
                    <td width=50 class=title>신용<br>등급</td>
                    <td width=80 class=title>견적일자</td>                    
                    <td width=90 class=title>차량가격</td>
                    <td width=90 class=title>적용잔가</td>					
                    <td width=80 class=title>월대여료</td>			
                    <td width=90 class=title>보증금</td>
                    <td width=70 class=title>선납금</td>									
                    <td width=70 class=title>개시대여료</td>												
					<td width=60 class=title>등록일</td>
					<td width=50 class=title>등록자</td>					
                </tr>
            <%for(int i=0; i<size; i++){
								bean = e_r[i];
								
								//if(!bean.getRent_st().equals(rent_st)) continue;
								if(bean.getFee_s_amt() ==  0 || bean.getFee_s_amt() < 0) continue;
					
								count++;
						%>
                <tr> 
                    <td align=center><%=count%></td>
                    <td align=center><%if(bean.getRent_st().equals("t")){%>출고전대차<%}else if(bean.getRent_st().equals("1")){%>신규<%}else{%>연장(<%=bean.getRent_st()%>)<%}%></td>			
                    <td align=center><a href="javascript:EstiDoc('<%=bean.getEst_id()%>')"><%= bean.getEst_id() %></a></td>
                    <td align=center><%=c_db.getNameByIdCode("0009", "", bean.getA_a())%></td>
                    <td align=center><%=bean.getA_b()%>개월</td>
                    <td align=center>
                  			<%if(bean.getSpr_yn().equals("3")){%>신설<%}%>
                  			<%if(bean.getSpr_yn().equals("0")){%>일반<%}%>
                  			<%if(bean.getSpr_yn().equals("1")){%>우량<%}%>
                  			<%if(bean.getSpr_yn().equals("2")){%>초우량<%}%>
                    </td>
                    <td align=center><%= AddUtil.ChangeDate2(bean.getRent_dt()) %></td>                    
                    <td align="right"><%=Util.parseDecimal(bean.getO_1())%></td>
                    <td align="right"><%=Util.parseDecimal(bean.getRo_13_amt())%></td>					
                    <td align="right">
                    <%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("임원",user_id)){%>
                    <a href="javascript:estimates_view('<%=bean.getRent_st()%>', '<%=bean.getReg_code()%>')" onMouseOver="window.status=''; return true" title="견적결과 보기"><%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%></a>
                    <%	}else{ %>
                    <%=Util.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt())%>
                    <%	} %>
                    </td>
                    <td align="right"><%=Util.parseDecimal(bean.getGtr_amt())%></td>
                    <td align="right"><%=Util.parseDecimal(bean.getPp_s_amt()+bean.getPp_v_amt())%></td>
                    <td align="right"><%=Util.parseDecimal(bean.getIfee_s_amt()+bean.getIfee_v_amt())%></td>												
                    <td align=center><%=bean.getReg_dt()%></td>
                    <td align=center><%=bean.getTalk_tel()%></td>										
                </tr>
                <%}%>
                <% if(size == 0) { %>
                <tr> 
                    <td align=center height=25 colspan="15">등록된 데이타가 없습니다.</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
