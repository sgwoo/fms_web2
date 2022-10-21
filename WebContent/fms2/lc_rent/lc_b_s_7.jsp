<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.user_mng.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정
	function update(idx){
		var fm = document.form1;
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}							
	}
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='lc_b_s_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" value="<%=user_id%>">
  <input type='hidden' name="br_id"   value="<%=br_id%>">
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>  
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_7.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">  
  <input type='hidden' name="idx"	value="">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결계약</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타참고사항</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>기타</td>
                    <td>&nbsp;<textarea name='dec_etc' rows='5' cols='100' maxlenght='500'><%=cont_etc.getDec_etc()%></textarea></td>
                </tr>
    		</table>	  
	    </td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객신용등급판정</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>적용신용등급</td>
                    <td colspan="2" class=title>심사</td>
                    <td colspan="2" class=title>결재</td>
                </tr>
                <tr>
                    <td width="20%" class=title>담당자</td>
                    <td width="20%" class='title'>판정일자</td>
                    <td width="20%" class=title>결재자</td>
                    <td width="27%" class='title'>결재일자</td>
                </tr>
                <tr>
                    <td align="center">
        	              <%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
                        <%if(AddUtil.parseInt(base.getRent_dt()) > 20141231 && !nm_db.getWorkAuthUser("심사",ck_acar_id) && !nm_db.getWorkAuthUser("전산팀",ck_acar_id) && !nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)){%>	        			
                            <!-- 
                            <%if(cont_etc.getDec_gr().equals("1")){%>우량기업<%}%>
                            <%if(cont_etc.getDec_gr().equals("2")){%>초우량기업<%}%>
                            <input type='hidden' name="dec_gr" 	value="<%=cont_etc.getDec_gr()%>">
                             -->
                            <select name='dec_gr'>  
                                <option value='2' <%if(cont_etc.getDec_gr().equals("2")){%>selected<%}%>>초우량기업</option>
                                <option value='0' <%if(cont_etc.getDec_gr().equals("0")){%>selected<%}%>>일반고객</option>
                                <option value='1' <%if(cont_etc.getDec_gr().equals("1")){%>selected<%}%>>우량기업</option>                                
                            </select>
                        <%}else{%>                        
                            <select name='dec_gr'>  
                                <option value='1' <%if(cont_etc.getDec_gr().equals("1")){%>selected<%}%>>우량기업</option>
                                <option value='2' <%if(cont_etc.getDec_gr().equals("2")){%>selected<%}%>>초우량기업</option>
                                <option value='3' <%if(cont_etc.getDec_gr().equals("3")){%>selected<%}%>>신설법인</option>
                                <option value='0' <%if(cont_etc.getDec_gr().equals("0")){%>selected<%}%>>일반고객</option>                                
                            </select>
                        <%}%>
                    </td>                       
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_f_id(), "USER")%>
			                  <input type="hidden" name="dec_f_id" value="<%=cont_etc.getDec_f_id()%>">
                    </td>
                    <td align="center"><input type='text' name='dec_f_dt' size='12' maxlength='20' class='text' value="<%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_l_id(), "USER")%>
			                  <input type="hidden" name="dec_l_id" value="<%=cont_etc.getDec_l_id()%>">
                    </td>
                    <td align="center"><input type='text' name='dec_l_dt' size='12' maxlength='20' class='whitetext' value='<%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%>' ></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('7')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
	<tr>	
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
//-->
</script>
</body>
</html>
