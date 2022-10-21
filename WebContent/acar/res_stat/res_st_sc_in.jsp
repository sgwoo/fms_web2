<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}		
	//�����̷�
	function view_sh_res_h(car_mng_id){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id="+car_mng_id;
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	//�˾������� ����
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.deli_plan_dt":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "01");
	
	Vector conts = rs_db.getResStatList_New(br_id, gubun1, gubun2, brch_id, start_dt, end_dt, car_comp_id, code, s_cc, s_year, s_kd, t_wd, sort_gubun, asc);
	int cont_size = conts.size();
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ڻ���������",user_id) || nm_db.getWorkAuthUser("�����������",user_id)){
		mng_mode = "A";
	}	
	String mng_mode2 = ""; 
	if(nm_db.getWorkAuthUser("������",user_id)){
		mng_mode2 = "A";
	}	
%>
<table border="0" cellspacing="0" cellpadding="0" width='1570'>
	<tr><td class=line2 colspan="2"></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='460' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='40' class='title'>����</td>
                    <td width='50' class='title'>����</td>
                    <td width='50' class='title'>���</td>
                    <td width='70' class='title'>��౸��</td>
                    <td width='120' class='title'>��ȣ</td>
					<td width='50' class='title'>����</td>
                    <td width='80' class='title'>������ȣ</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1110'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    		    <tr>
                    	    <td width='200' class='title'>����</td>
                    	    <td width='80' class='title'>����������ȣ</td>					
                    	    <td width='100' class='title'>������������</td>			
        	    	    <td width='80' class='title'>�������</td>
        		    <td width='140' class='title'>�뿩������</td>
        		    <td width='140' class='title'>�뿩������</td>		  		  
        		    <td width='140' class='title'>���������Ͻ�</td>
        		    <td width='40' class='title'>����</td>
        		    <td width='70' class='title'>���ʿ�����</td>
        		    <td width='70' class='title'>���������</td>
        		    <td width='50' class='title'>�����</td>
    		    </tr>
    	    </table>
	    </td>
    </tr>
<%	if(cont_size > 0){	%>
    <tr>
	    <td class='line' width='460' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>	
                <tr> 
                    <td width='40' align='center'><%=i+1%></td>		  
                    <td width='50' align='center'>
        		    <%if(!String.valueOf(reserv.get("RENT_ST")).equals("������") && !String.valueOf(reserv.get("RENT_ST")).equals("�����") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
        		    <a href="javascript:parent.reserve_action('Y', '<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>','','','');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_bcha.gif"  align="absmiddle" border="0"></a>         		   
        			<%}else{%>
        			-
        			<%}%>
                    </td>
                    <td width='50' align='center'>
        		    <%if(mng_mode2.equals("A") || String.valueOf(reserv.get("BUS_ID")).equals(user_id) || (!String.valueOf(reserv.get("RENT_ST")).equals("������") && !String.valueOf(reserv.get("RENT_ST")).equals("�����") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")))){%>
        		    <a href="javascript:parent.reserve_action('N', '<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>','<%=reserv.get("CAR_NO")%>','','<%=reserv.get("CUST_NM")%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_cancel.gif"  align="absmiddle" border="0"></a>        		    
        			<%}else{%>
        			-
        			<%}%>
                    </td>
                    <td width='70' align='center'><font color="#0080C0"><b><%=reserv.get("RENT_ST")%></b></font></td>		  
                    <td width='120'>&nbsp;<font color="#808080"><span title='<%=reserv.get("CUST_NM")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("CUST_NM")), 17)%></span></font>
                      <%if(String.valueOf(reserv.get("CUST_NM")).equals("")){%>
                        <%if(String.valueOf(reserv.get("ETC")).indexOf("�縮���������� ���Ȯ�� �ڵ�����") != -1){%>
                        <a href="javascript:view_sh_res_h('<%=reserv.get("CAR_MNG_ID")%>')" title="�̷�"><span title='<%=reserv.get("ETC")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("ETC")), 15)%></span></a>
                        <%}else{ %>
                    	<span title='<%=reserv.get("ETC")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("ETC")), 15)%></span>
                    	<%} %>
                      <%}%>                    
                    </td>		  
					<td width='50' align='center'>
					<%if(String.valueOf(reserv.get("RM_ST")).equals("�����")){%><font color=red><%}%>
					<%=reserv.get("RM_ST")%>
					<%if(String.valueOf(reserv.get("RM_ST")).equals("�����")){%></font><%}%>
					</td>							
                    <td width='80' align='center'><a href="javascript:parent.view_cont('<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=reserv.get("CAR_NO")%></a></td>
                </tr>
        <%	}%>
            </table>
	    </td>
	    <td class='line' width='1110'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable reserv = (Hashtable)conts.elementAt(i);%>			
                <tr>
                    <td width='200'>&nbsp;<span title='<%=reserv.get("CAR_NM")%> <%=reserv.get("CAR_NAME")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("CAR_NM"))+" "+String.valueOf(reserv.get("CAR_NAME")), 25)%></span></td>		
                    <td width='80' align='center'><%=reserv.get("D_CAR_NO")%></td>	
                    <td width='100' align='center'>&nbsp;<span title='<%=reserv.get("D_CAR_NM")%>'><%=AddUtil.substringbdot(String.valueOf(reserv.get("D_CAR_NM")), 12)%></span></td>						
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("RENT_DT")))%></td>
                    <td width='140' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RENT_START_DT")))%></td>
                    <td width='140' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RENT_END_DT")))%>
                    	
                    	</td>		  
                    <td width='140' align="center"><%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_PLAN_DT")))%></td>
                    <td width='40' align='center'><%=reserv.get("BRCH_ID")%></td>
                    <td width='70' align="center"><%=reserv.get("BUS_NM")%></td>
                    <td width='70' align="center"><%=reserv.get("MNG_NM")%></td>
                    <td width='50' align='center'>
        		    <%if(String.valueOf(reserv.get("ETC")).indexOf("�ڻ����� �������� ���") != -1 && mng_mode.equals("A")){%>
        		    <a href="javascript:parent.reserve_action('J', '<%=reserv.get("RENT_S_CD")%>', '<%=reserv.get("CAR_MNG_ID")%>','<%=reserv.get("CAR_NO")%>','','<%=reserv.get("CUST_NM")%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_modify.gif"  align="absmiddle" border="0"></a>        		    
        			<%}else{%>
        			-
        			<%}%>
                    </td>                    
                </tr>
		<%	}%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='460' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='1110'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
        		    <td>&nbsp;</td>
        		</tr>
    	    </table>
		</td>
	</tr>
<%	}	%>
</table>
</body>
</html>

