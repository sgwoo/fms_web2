<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.car_mst.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="atp_db" scope="page" class="acar.kakao.AlimTemplateDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"2":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
		
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
			
	//cont_view
	Hashtable cont = a_db.getContViewCase(m_id, l_cd);
	String car_num = String.valueOf(cont.get("CAR_NO"));
	String car_name = String.valueOf(cont.get("CAR_NM"));
	String firm_nm= String.valueOf(cont.get("FIRM_NM")); // 고객 
	 	   
  	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "");
	int mgr_size = car_mgrs.size();
	String f_person = "";
    String s_person = "";
    for(int i = 0 ; i < mgr_size ; i++){
		CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
       	if(mgr.getMgr_st().equals("추가이용자") || mgr.getMgr_st().equals("추가운전자")){
        	s_person =mgr.getMgr_nm();
       	}
   	} 
   	  
  	UsersBean sener_user_bean = umd.getUsersBean(ck_acar_id);
  
  	String url3 = "http://fms1.amazoncar.co.kr/fms2/cls_cont/lc_cls_print.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
    	
	String msg = "";
	
	msg = firm_nm +  " 님  아마존카입니다.\n\n" + 
	     "["+ car_num + "] 차량의  해지정산내역입니다. \n\n" + url3 + " " ;

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function setSmsMsg(){
		var fm = document.form1;		
		parent.document.form1.msg.value = fm.msg.value;		
		self.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='scd_size' value=''>
<input type='hidden' name='s_cnt' value='<%=s_cnt%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>메시지<span class=style5> (해지정산)</span></span></td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>        
   
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>해지 정산 안내</td>
                    <td colspan="3">&nbsp;
					            <textarea name='msg' rows='20' cols='72' class='text' readOnly style='IME-MODE: active'><%=msg%></textarea>
					            &nbsp;&nbsp;<a href="javascript:setSmsMsg();"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	parent.document.form1.msg_subject.value = '[해지 정산 안내]';	
	setSmsMsg();	

//-->
</script>
</body>
</html>