<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.cont.*" %>
<%@ page import="acar.cus0401.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String m_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

 	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "Y");
	int mgr_size = car_mgrs.size();
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function mgr_addr(mgr_st){
	var fm = document.form1;
	window.open('/acar/car_rent/mgr_addr.jsp?auth_rw='+fm.auth_rw.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&mgr_st='+mgr_st, "MGR_ADDR", "left=100, top=100, width=650, height=170, scrollbars=yes");
}
/*차량관리자정보-------------------------------------------------------------------------------------------------------------*/

	//수정: 차량관리자 선택
	function select_mgr(idx, nm)
	{
		var fm = document.form1;
		fm.h_mgr_id_s.value 	= fm.h_mgr_id[idx].value;
		fm.t_mgr_st_s.value 	= nm;
		fm.t_mgr_dept_s.value 	= fm.t_mgr_dept[idx].value;
		fm.t_mgr_nm_s.value 	= fm.t_mgr_nm[idx].value;
		fm.t_mgr_title_s.value 	= fm.t_mgr_title[idx].value;
		fm.t_mgr_tel_s.value 	= fm.t_mgr_tel[idx].value;
		fm.t_mgr_mobile_s.value = fm.t_mgr_mobile[idx].value;
		fm.t_mgr_email_s.value 	= fm.t_mgr_email[idx].value;
	}
	
	//수정: 차량관리자 수정,추가
	function update_mgr(idx)
	{
		var fm = document.form1;
		if(fm.t_mgr_st_s.value == ''){					alert('차량관리자 구분명을 입력하십시오');	return;	}
		else if(idx=='0' && fm.h_mgr_id_s.value!=''){	alert('이미 등록된 차량관리자입니다');		return;	}
		else if(idx=='1' && fm.h_mgr_id_s.value==''){	alert('등록되지 않은 차량관리자입니다');	return;	}
		else if(fm.h_mgr_id_s.value == '0' && fm.t_mgr_st_s.value != '차량이용자'){ alert('차량이용자 구분명을 수정할 수 없습니다'); return; }
		else if(fm.h_mgr_id_s.value == '1' && fm.t_mgr_st_s.value != '차량관리자'){ alert('차량관리자 구분명을 수정할 수 없습니다'); return; }
		else if(fm.h_mgr_id_s.value == '2' && fm.t_mgr_st_s.value != '회계관리자'){ alert('회계관리자 구분명을 수정할 수 없습니다'); return; }
		fm.mode.value = idx;
		fm.target='i_no';
		fm.action='./cus0401_d_sc_carmgr_iu.jsp';
		fm.submit();
	}		

/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	}
	
	function init(){		
		setupEvents();
	}
//-->
</script>
</head>

<body onLoad="javascript:init()">
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type="hidden" name="mode" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr id='tr_title' style='position:relative;z-index:1'> 
                    <td class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class=title width=10%>구분</td>
                                <td class=title width=11%>근무부서</td>
                                <td class=title width=10%>성명</td>
                                <td class=title width=10%>직위</td>
                                <td class=title width=11%>전화번호</td>
                                <td class=title width=11%>휴대폰</td>
                                <td class=title width=17%>E-MAIL</td>
                                <td class=title align='center' width=20%>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="line">
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                   <% 	if(mgr_size > 0){
        		for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i); %>
                            <tr> 
                                <td align='center' width=10%> <input type='hidden' name='h_mgr_id' size='10' class='text' value='<%=mgr.getMgr_id()%>'> 
                                  <a href="javascript:select_mgr(<%=i%>, '<%= mgr.getMgr_st()%>')" onMouseOver="window.status=''; return true"><%= mgr.getMgr_st()%></a> 
                                </td>
                                <td align='center' width=11%> <input type='text' name='t_mgr_dept' value='<%= mgr.getMgr_dept()%>' size='13' maxlength='15' class='white'  style='IME-MODE: active'></td>
                                <td align='center' width=10%> <input type='text' name='t_mgr_nm' value='<%= mgr.getMgr_nm()%>' size='12' maxlength='20' class='white'> 
                                </td>
                                <td align='center' width=10%> <input type='text' name='t_mgr_title' value='<%= mgr.getMgr_title()%>' size='12' maxlength='10' class='white' style='IME-MODE: active'> 
                                </td>
                                <td align='center' width=11%> <input type='text' name='t_mgr_tel' value='<%= mgr.getMgr_tel()%>' size='13' maxlength='15' class='white'> 
                                </td>
                                <td align='center' width=11%> <input type='text' name='t_mgr_mobile' value='<%= mgr.getMgr_m_tel()%>' size='13' maxlength='15' class='white'> 
                                </td>
                                <td align='center' width=17%> <input type='text' name='t_mgr_email' value='<%= mgr.getMgr_email()%>' size='22' maxlength='30' class='white' style='IME-MODE: inactive'> 
                                </td>
                                <td align='center' width=20%> 
                                  <%if(mgr.getMgr_st().equals("차량이용자")){%>
                                  <a href="javascript:mgr_addr('차량이용자');"><img src="/acar/images/center/button_addr.gif" align="absmiddle" border="0"></a> 
                                  <%}%>
                                </td>
                            </tr>
                      <% 		}
        					} %>
        		            <tr> 
                                <td align='center' width=10%> <input type='hidden' name='h_mgr_id_s' size='10' class='text' value=''> 
                                  <input type='text' name='t_mgr_st_s'    size='12'  value='' class='text' style='IME-MODE: active'> 
                                </td>
                                <td align='center' width=11%> <input type='text' name='t_mgr_dept_s'  size='13' maxlength='15' class='text'> 
                                </td>
                                <td align='center' width=10%> <input type='text' name='t_mgr_nm_s'    size='12' maxlength='20' class='text'> 
                                </td>
                                <td align='center' width=10%> <input type='text' name='t_mgr_title_s' size='12' maxlength='10' class='text'> 
                                </td>
                                <td align='center' width=11%> <input type='text' name='t_mgr_tel_s'   size='13' maxlength='15' class='text'> 
                                </td>
                                <td align='center' width=11%> <input type='text' name='t_mgr_mobile_s' size='13' maxlength='15' class='text'> 
                                </td>
                                <td align='center' width=17%> <input type='text' name='t_mgr_email_s' size='22' maxlength='30' class='text' style='IME-MODE: inactive'> 
                                </td>
                                <td align='center' width=20%> 
                                  <%//if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                                  <a href="javascript:update_mgr('1');"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a> 
                                  <%//}%>
                                  <%//if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                                  &nbsp;<a href="javascript:update_mgr('0');"><img src="/acar/images/center/button_in_plus.gif" align="absmiddle" border="0"></a> 
                                  <%//}%>
                                </td>
                            </tr>			
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>  
</table>
</form>
</body>
</html>
