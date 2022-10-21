<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.esti_mng.*, acar.car_office.*" %>
<jsp:useBean id="EstiMngDb" class="acar.esti_mng.EstiMngDatabase" scope="page" />
<jsp:useBean id="EstiRegBn" class="acar.esti_mng.EstiRegBean" scope="page"/>
<jsp:useBean id="EstiListBn" class="acar.esti_mng.EstiListBean" scope="page"/>
<jsp:useBean id="EstiContBn" class="acar.esti_mng.EstiContBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	EstiRegBn = EstiMngDb.getEstiReg(est_id);
	
	String s_kd2 = "", t_wd2 = "";
	if(gubun.equals("firm")){
		s_kd2 = "4";
		t_wd2 = EstiRegBn.getEst_nm()+EstiRegBn.getEst_mgr();
	}else{
		s_kd2 = "5";
		t_wd2 = EstiRegBn.getEmp_id();
		
		CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
		if(!EstiRegBn.getEmp_id().equals("")){
			coe_bean = cod.getCarOffEmpBean(EstiRegBn.getEmp_id());
			co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
		}
	}
	Vector EstiList = EstiMngDb.getEstiList("", "", "", "", "", "", "", "", "", "", "", s_kd2, t_wd2, "", "", "", "", "");
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//내용보기
	function EstiDisp(est_id){	
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.target = 'd_content';
		fm.submit();
		
		window.close();
	}	
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="./esti_ing_u.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">    
    <input type="hidden" name="gubun6" value="<%=gubun6%>">    	
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="s_year" value="<%=s_year%>">
    <input type="hidden" name="s_mon" value="<%=s_mon%>">
    <input type="hidden" name="s_day" value="<%=s_day%>">	
    <input type="hidden" name="est_id" value="">
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>
                    <%if(gubun.equals("firm")){%>
                    <%= EstiRegBn.getEst_nm()%> <%= EstiRegBn.getEst_mgr()%> 
                    <%}else{%>
                    <%= coe_bean.getCar_comp_nm()%> <%= coe_bean.getCar_off_nm()%> <b><font color="#990000"><%= coe_bean.getEmp_nm()%> 
                    <%= coe_bean.getEmp_pos()%></font></b> 
                    <%}%>
                    </span><b>견적이력</b></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td colspan="2" align="right">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width="5%">연번</td>
                    <td class=title width="12%">견적일자</td>
                    <td class=title width="39%">차종</td>
                    <td class=title width="12%">차량가격</td>
                    <td class=title width="10%">견적상태</td>
                    <td class=title width="10%">마감결과</td>
                    <td class=title width="12%">미체결구분</td>
                </tr>
            <% if(EstiList.size()>0){
    				for(int i=0; i<EstiList.size(); i++){ 
    					Hashtable ht = (Hashtable)EstiList.elementAt(i); %>	  				  
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><a href="javascript:EstiDisp('<%= ht.get("EST_ID") %>')"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT"))) %></a></td>
                    <td align="center"><%= ht.get("CAR_NAME") %><%if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){%>(<%= ht.get("CAR_NO") %>)<%}%></td>
                    <td align="right"><%= AddUtil.parseDecimal(String.valueOf(ht.get("O_1"))) %>원</td>
                    <td align="center"><%= ht.get("EST_ST_NM") %></td>
                    <td align="center"><%= ht.get("END_TYPE_NM") %></td>
                    <td align="center"><%= ht.get("NEND_ST_NM") %></td>
                </tr>
            <% 		}
    			}else{ %>
                <tr> 
                    <td colspan="7" align='center'>해당 데이터가 없습니다.</td>
                </tr>
            <% } %>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="2" align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>