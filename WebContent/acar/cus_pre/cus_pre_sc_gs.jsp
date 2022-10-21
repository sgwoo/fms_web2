<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*, acar.accid.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	LoginBean login = LoginBean.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	if  ( !user_nm.equals("��ü") ) {
		Hashtable id = c_db.getDamdang_id(user_nm);
		user_id = String.valueOf(id.get("USER_ID"));
	} else {
	          user_id = "";
	}
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "01", "01");	
	
	CusPre_Database cp_db = CusPre_Database.getInstance();
	
	Vector cmls = cp_db.getCar_maintList(user_id, s_kd, t_wd);
				

	//���������� ���ɸ��Ό��
	Vector vt3 = ad_db.getCarEndDtEstList(user_id);
	int vt_size3 = vt3.size();
	
	
	//�ѱ�����������ܱ���  ���⵵�� 5���� (fms�� �Է��� �ȵǾ������� ����Ʈ ������)
    Vector vt4 = ad_db.getCarCybertsList();
	int vt_size4 = vt4.size();
	
	String regdt="";
	
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//�˻��ϱ�	
function adjust_vst(client_id,seq){
	var SUBWIN="../cus_reg/vst_reg.jsp?client_id=" + client_id + "&seq=" + seq + "&page_nm=cus_pre_sc_gs&user_id=<%= user_id %>";
	window.open(SUBWIN, 'popwin_vst_reg','scrollbars=yes,status=no,resizable=no,width=850,height=320,top=50,left=50');
}
function go_cus_reg_visit(firm_nm){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=1&t_wd="+firm_nm;
	fm.target = "d_content";
	fm.submit();
}
function go_cus_reg_serv(car_no){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=2&s_kd=2&t_wd="+car_no;
	fm.target = "d_content";
	fm.submit();
}

function go_cus_reg_maint(car_no){
	var fm = document.form1;
	fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=3&s_kd=2&t_wd="+car_no;
	fm.target = "d_content";
	fm.submit();
}

function serv_apply(rmid,rlcd,irid){
	var fm = document.form1;
	if(!confirm('�ش� ������� �Ϸ� �Ͻðڽ��ϱ�?')){ return; }	
	fm.target = "i_no";
	fm.action = "../cus0404/serv_apply_ok.jsp?rent_mng_id="+rmid+"&rent_l_cd="+rlcd+"&ires_id="+irid+"&page_nm=cus_pre_sc_gs&user_id=<%= user_id %>";
	fm.submit();
}
	//�� ����
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
		function AccidentDisp(m_id, l_cd, c_id, accid_id, accid_st, idx){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.accid_id.value = accid_id;		
		fm.accid_st.value = accid_st;				
		fm.idx.value = idx;						
		fm.cmd.value = "u";	

		var url = "?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&accid_id="+accid_id+"&accid_st="+accid_st+"&idx="+idx;
		var SUBWIN = "/acar/accid_mng/accid_u_frame.jsp" + url;
	//	window.open(SUBWIN, 'AccidentDisp','scrollbars=yes,status=no,resizable=no,width=900,height=700,top=50,left=50');

		fm.action='/acar/accid_mng/accid_u_frame.jsp';
		fm.target = "d_content";
		fm.submit();
	}
	
function next_serv_cng(car_mng_id, serv_id){
	var theForm = document.form1;
	var auth_rw = theForm.auth_rw.value;	
	var url = "?auth_rw=" + auth_rw
			+ "&car_mng_id=" + car_mng_id
			+ "&serv_id=" + serv_id;

	var SUBWIN="/acar/cus_sch/next_serv_cng.jsp" + url;	
	
	window.open(SUBWIN, 'popwin_next_serv_cng','scrollbars=yes,status=no,resizable=no,width=440,height=150,top=200,left=500');
}

//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

function multireg() {
	var fm=document.form1;
	
	fm.action='/acar/cus_pre/car_req_master2.jsp';
	fm.target='_blank';
	fm.submit();
}

function dg_input(number)
{
	var SUBWIN="http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1="+number; //��ü�������ȸ��ũ
	window.open(SUBWIN, "dg_input", "left=50, top=50, width=850, height=300, resizable=yes, scrollbars=yes");
}		

function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}
	
function view_email(m_id, l_cd, c_id){
		window.open("http://fms1.amazoncar.co.kr/mailing/ser/insp.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id, "VIEW_EMAIL", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}	
function view_sms(m_id, l_cd, c_id, car_no){
		window.open("/acar/cus_pre/cus_pre_sms.jsp?m_id="+m_id+"&l_cd="+l_cd+"&c_id="+c_id+"&car_no="+car_no+"&auth_rw=<%=auth_rw%>", "VIEW_EMAIL", "left=100, top=100, width=800, height=550, scrollbars=yes");
	}	
	function serv_action(car_mng_id, serv_id, accid_id){
		var fm = document.form1;
		var SUBWIN="/acar/cus_reg/serv_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id+"&from_page=/acar/cus_pre/cus_pre_sc_gs.jsp"; 
		window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=720,top=50,left=50');
	}
	
	
	function cus_pre_c(car_mng_id, car_no, m_id , l_cd){

	var SUBWIN="/acar/cus_pre/cus_pre_c.jsp?c_id=" + car_mng_id+"&car_no="+car_no+"&m_id="+m_id+"&l_cd="+l_cd;	
	
	window.open(SUBWIN, 'AncDisp','scrollbars=yes,status=no,resizable=no,width=680,height=450,top=200,left=300');
}
	
-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><a name='0'></a></td>
    </tr>
     <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ѱ������������ �˻絵�� 7���� ����  : �� <font color="#FF0000"><%= vt_size4 %></font>��</span>
        &nbsp;&nbsp;<a href="javascript:var win=window.open('cyberts_reg.jsp','popup','left=10, top=10, width=900, height=600, status=no, scrollbars=yes, resizable=no');"><img src=/acar/images/center/button_excel_dr.gif align=absmiddle border=0></a>
       &nbsp;&nbsp;<span>[<b>Excel���չ���</b> �Ǵ� <b>Excel97-2003 ���չ���</b>] �� �����Ͽ��� �ٸ��̸����� ���� �� ����ϼž� �մϴ�</span> 
        </td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;* �ش� ����Ʈ�� ������ �˻縦 �����Ͽ�� ���� ������Ͻñ��� ������� ������ ������ �����ϼ���!!!.          
        </td>
    </tr>
   <tr>
        <td>&nbsp;&nbsp;&nbsp;<b>* ���������:&nbsp;  
     <%if(vt_size4 > 0){          
				for (int i = 0 ; i < 1 ; i++){
				          	   
						Hashtable ht1 = (Hashtable)vt4.elementAt(i);
						
						regdt= String.valueOf(ht1.get("REG_DT"));
				%>    
   <% } }%>
        <%=regdt %> </b>         
        </td>
    </tr>
   
					
    
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='3%' class='title'>����</td>
                    <td width='14%' class='title'>��ȣ</td>                  
                    <td width='8%' class='title'>������ȣ</td>
                    <td width='9%' class='title'>�����ȣ</td> 
                    <td width='13%' class='title'>����</td>
                    <td width='7%' class='title'>��ȿ�Ⱓ<br>������</td>
                    <td width='7%' class='title'>���ɱⰣ<br>������</td>
                    <td width='4%' class='title'>����</td>
                    <td width='6%' class='title'>���Ⱑ�� ���</td>
                    <td width='7%' class='title'>���ʵ����</td>
                    <td width='7%' class='title'>��ุ����</td>   
                    <td width='7%' class='title'>�������</td>
                    <td width='8%' class='title'>������ȣ</td>
                </tr>
                        
          <%if(vt_size4 > 0){
          
				for (int i = 0 ; i < vt_size4 ; i++){
				          	   
						Hashtable ht = (Hashtable)vt4.elementAt(i);
					%>
                <tr>
                    <td align="center"><%=i+1%></td>            
                    <td align="center"><%if(String.valueOf(ht.get("RRM")).equals("0")){%><b>(��)</b><%} %>&nbsp;<%=ht.get("FIRM_NM") %></td>
                    <td align="center"><%= ht.get("CAR_NO") %></td>
                    <td align="center"><%= ht.get("CAR_NUM") %></td>            
                    <td align="center"><%= ht.get("CAR_NAME") %></td>
                    <td align="center"><%= ht.get("END_DT") %></td>
                    <td align="center"><%= ht.get("CAR_END_DT") %></td>
                    <td align="center"><%= ht.get("CAR_YY") %></td>
                    <td align="center"><%= ht.get("CAR_TYPE") %></td>    
 					<td align="center"><%= ht.get("INIT_REG_DT") %></td>
 					<td align="center"><%= AddUtil.ChangeDate2((String)ht.get("RENT_END_DT")) %></td>
 					<td align="center"><%= c_db.getNameById((String)ht.get("BUS_ID2"),"USER") %></td>
 					<td align="center"><%= ht.get("CAR_DOC_NO") %></td>
                 
		        </tr>
          <%  }
			}else{%>  
                <tr>
                    <td colspan="14" align="center">�ڷᰡ �����ϴ�.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>	  
     <tr> 
        <td><a name='1'></a></td>
    </tr>	
            
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ���� <b>���ɸ���</b>���� (D-90��) : �� <font color="#FF0000"><%= vt_size3 %></font>��</span></td>
    </tr>
     <tr>
        <td>&nbsp;&nbsp;&nbsp;* ���ɿ���� �ӽð˻�� ���ɸ����� 2���������� �����մϴ�.
             <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ӽð˻��� ���ɸ���ó���� ���ؼ�  ��û�湮���� �ð��� �ҿ�ǿ��� ����� �����ð��� �ΰ� ó���ϼž� �մϴ�.          
              <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ɸ����� 1���������� ������ �ӽð˻� �ϷῩ�θ� Ȯ���ϼż� �������� ������ �����ϼž�  �մϴ�.  
             <br>&nbsp;&nbsp;&nbsp;<font color="blue">* ������ȣ���� �������� Ŭ���Ͽ� �˻�� Ư�̻����� ������ �Է��Ͽ� ������ �� �ֽ��ϴ�.!!!</font>                                  
        	   <br>&nbsp;&nbsp;&nbsp;* �����ڵ���,<font color="red">�̽��͹ڴ븮(����)</font>���� �����մϴ�. ������ �����Ĵ�� �������ּ���!!!! 
       
        </td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='3%' class='title'>����</td>
                    <td width='12%' class='title'>��ȣ</td>                  
                    <td width='8%' class='title'>������ȣ</td>
                    <td width='6%' class='title'>�Ƿ���</td>
                    <td width='10%' class='title'>����</td>
                    <td width='5%' class='title'>��ⷮ</td>
                    <td width='7%' class='title'>�����</td>
                    <td width='6%' class='title'>��ุ����</td>
                    <td width='6%' class='title'>���ɸ�����</td>              
                    <td width='6%' class='title'>���ɿ���<br>����</td>
				<!--	<td width='8%' class='title'>�����Ȳ</td> -->
					<td width='7%' class='title'>�����Ȳ</td>
                    <td class=title width=12% >�ӽð˻�Ⱓ</td>    					
                    <td width='6%' class='title'>�������</td>
                    <td width='7%' class='title'>������ȣ</td>
                </tr>
                
          <%if(vt_size3 > 0){
          
            		String s_end_dt = "";          
          	   	String i_end_m_60  = "";
          	             	   
				for (int i = 0 ; i < vt_size3 ; i++){
				
          	   
						Hashtable ht = (Hashtable)vt3.elementAt(i);
					
						s_end_dt = String.valueOf(ht.get("EST_CAR_END_DT"));  //���ɸ��Ό���� 	
        				i_end_m_60 = c_db.addDay(s_end_dt, -60);
					
					%>
                <tr>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>  
                    <a class=index1  href="javascript:MM_openBrWindow('car_req_master.jsp?gubun=Y&mng_id=<%=ht.get("BUS_ID2")%>&c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>&l_cd=<%=ht.get("RENT_L_CD")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=620,height=350,left=50, top=50')"> 
                                <%=i+1%></a></td>            
                    <td align="center"  <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%if(String.valueOf(ht.get("RRM")).equals("0")){%><b>(��)</b><%} %>&nbsp;<%= ht.get("FIRM_NM") %></td>

                    <td align="center"  <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                      <% if ( ht.get("M1_CHK").equals("3") ) { %><font color=#ba03fe>
                      <%} else if ( ht.get("M1_CHK").equals("A") ) {%><font color=green>
                      <%} else if ( ht.get("M1_CHK").equals("6") ) {%><font color=red><%}%><%= ht.get("CAR_NO") %><% if ( ht.get("M1_CHK").equals("3")  ||  ht.get("M1_CHK").equals("6") ||  ht.get("M1_CHK").equals("A")) {%></font><% } %>
             			  <a href="javascript:cus_pre_c('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("CAR_NO")%>',  '<%=ht.get("RENT_MNG_ID")%>' ,  '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='Ư�̻���'><img src=/acar/images/center/icon_memo.gif align=absmiddle border=0></a>
              
               <!--      <a href="javascript:MM_openBrWindow('/fms2/car_board/car_board_frame.jsp?car_mng_id=<%=String.valueOf(ht.get("CAR_MNG_ID"))%>&m_id=<%=String.valueOf(ht.get("RENT_MNG_ID"))%>&l_cd=<%=String.valueOf(ht.get("RENT_L_CD"))%>&gubun=MA','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a> -->
                     
                      </td>
 					 <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                     <% if(!ht.get("M1_CHK").equals("1") && !ht.get("M1_CHK").equals("2") && !ht.get("M1_CHK").equals("3") && !ht.get("M1_CHK").equals("5")  && !ht.get("M1_CHK").equals("6") && !ht.get("M1_CHK").equals("A") ) {%>
                    &nbsp;<% } else { %><%=ht.get("M1_DT")%><%}%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("CAR_NM")%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("DPM")%>cc</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                    <td align="center"  <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_CAR_END_DT")))%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                        <%if(String.valueOf(ht.get("CAR_END_YN")).equals("Y")){%>��������<%}%>
                    </td>
				<!--	<td align="center"><%if(ht.get("DG_YN").equals("Y")){%>ó���Ϸ�<%}else if(ht.get("DG_YN").equals("N")){%><a href="javascript:dg_input('<%=ht.get("DG_NO")%>')">����߼�</a><%}else{%><%}%></td> -->
					<td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
						<%if(ht.get("OFF_LS").equals("5")){%>����
					<!--	<%//}else if(ht.get("OFF_LS").equals("1")){%>�Ű����� -->
						<%}else if(ht.get("OFF_LS").equals("3")){%>�����
						<%}else if(ht.get("OFF_LS").equals("6")){%>�Ű�
						<%}%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>                        	
                    <%=i_end_m_60%>~<%=ht.get("EST_CAR_END_DT")%>
                    </td>						
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("USER_NM")%></td>         
                     <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)ht.get("EST_CAR_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%=ht.get("CAR_DOC_NO")%></td>           
		        </tr>
          <%  }
			}else{%>  
                <tr>
                    <td colspan="14" align="center">�ڷᰡ �����ϴ�.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>	  
    <tr> 
        <td><a name='2'></a></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ <b>���� / ���а˻�</b> �̽ǽ� (D��30��) : �� <font color="#FF0000"><%= cmls.size() %></font>��</span></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;* �˻���ȿ�Ⱓ/������ȿ�Ⱓ�� �����˻簡 �̷������ ���� �������� �ϸ�, �˻�Ⱓ�� ���ʵ������ �������� �����մϴ�.
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ �˻�Ⱓ ��/�ĸ� ������ �˻��� ��� ��¥ ���̰� �߻��Ǵ� �����ϼż� �˻�Ⱓ üũ�Ͻ� �� �����ϼž� �մϴ�.                
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��������  8���̻��� 6�������� ����,�����̹Ƿ� <font color=red>����</font>�� Ȯ���ϼž� �մϴ�. 
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ȭ��  5���̻��� 6�������� ����,�����̹Ƿ� <font color=red>����</font>�� Ȯ���ϼž� �մϴ�. 
        	   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* ����Ÿ�ڵ���/�����ڵ����� �˻������ �Ƿ��� ��쿡�� �ش� ������ ������ �� �Ƿڵ�ϸ� �����Ͽ� �����ϼ���.!!</font> 
        	   <!-- <br>&nbsp;&nbsp;&nbsp;<font color="blue">* ����Ÿ/�ϵ�����/�̽��͹ڴ븮�� �Ƿڵ� ������ ������ȣ�� </font><font color=red>����</font><font color=blue>,������ �Ƿڵ� ������ ������ȣ�� <font color=#ba03fe>�����</font><font color=blue>���� ǥ�õ˴ϴ�!! -->
        	   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* ����Ÿ/������Ƽ/�̽��͹ڴ븮/���񼭿� �Ƿڵ� ������ ������ȣ�� </font><font color=red>����</font><font color=blue>,������ �Ƿڵ� ������ ������ȣ�� <font color=#ba03fe>�����</font>,�������뿡 �Ƿڵ� ������ ������ȣ�� <font color=green>���</font><font color=blue>���� ǥ�õ˴ϴ�!!
        	   <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����, �˻��Ƿ� ��û�� �Ƹ���ī�� ����Ÿ/�����ڵ����� ���� �����ϰ� ��ó���� �� �� �ֵ��� ����� �����ð��� �ΰ� ó���ϼž� �մϴ�.</font>
        	   <br>&nbsp;&nbsp;&nbsp;* ����ڰ� ���� �˻縦 �ϰڴٰ� ������ ��� ������ȣ�� <font color=blue><b>�Ķ���</b></font> ���� ǥ�� �˴ϴ�.
        	   <br>&nbsp;&nbsp;&nbsp;<font color=red>* ���¾�ü�� ��Ź�Ͽ� �˻簡 �Ϸ�� ���� ���� ���ϳ��� ����ڰ� �ݵ�� �˻����� �ϼž� �մϴ�. �˻�Ⱓ �絵���� ������ ���� �� �ֽ��ϴ�.</font>  
        <!--	   <br>&nbsp;&nbsp;&nbsp;<font color=red>* ���������Ͽ� ���� ���˱�Ϻ� �˻���ȿ�Ⱓ�� 3���� ��찡 �ֽ��ϴ�. �������� Ȯ���ϼż� �ڵ������� �����ϼž� �մϴ�. 20131118 ���� ���� ������ -->
			   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* ������ȣ���� �������� Ŭ���Ͽ� �˻�� Ư�̻����� ������ �Է��Ͽ� ������ �� �ֽ��ϴ�.!!!</font>     
			   <br>&nbsp;&nbsp;&nbsp;<font color=red>* ����(<img src=/acar/images/center/e_mail.gif align=absmiddle border=0>) �������� Ŭ���Ͻø� ���� ���ۿ��θ� �����Ͻ� �� �ֽ��ϴ�. [Ȯ��]��ư�� ����/[���]��ư�� ������ �Դϴ�.</font>  
			   </font>  
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td><a href="javascript:multireg()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp; * ���� ���� �̰˻� ������ �� ���� ����ϱ� ���ҽ�, �ش� ������ üũ �� ��� ��ư�� ��������. </td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%"  class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                	<td class=title width=3%>����</td>
                    <td class=title width=3%>����</td>
                    <td class=title width=9%>��ȣ</td>
                    <td class=title width=6%>������ȣ</td>
                     <td class=title width=5%>�Ƿ���</td>
                    <td width='6%' class='title'>����</td>                    
              <!--      <td class=title width=4%>����<br>����</td> -->
                           <td class=title width=6%>���ʵ����</td>
                    <td class=title width=6%>��ุ����</td>
                    <td class=title width=6%>���<br>����</td>
         
                    <td class=title width=6%>�׸�</td>
                    <td class=title width=11%>�˻���ȿ�Ⱓ</td>    
                    <td class=title width=3%>����</td>
                    <td class=title width=3%>����</td>
     <!--               <td class=title width=11% >������ȿ�Ⱓ</td>      -->      
                    <td class=title width=10%>�˻�Ⱓ</td>
                    <td class=title width=5%>����<br>���</td>
                    <td class=title width=5%>���</td>
                    <td class=title width=7%>����<br>��ȣ</td>			
                </tr>
              
          <%if(cmls.size() > 0){
          	
          	   String s_car_kd = "";
          	   String s_car_use = "";
   //       	   String s_car_use1 = "";
          	   String s_init_reg_dt = "";
          	   String s_car_ext = "";
          	   String s_gubun = "";
          	   int i_chk1 = 0;
          	   int i_chk2 = 0;
          	   int i_chk3 = 0;
          	          	          	   
          	   int i_chk2_m_30 = 0;
          	   int i_chk2_p_30 = 0;
          	   int i_chk3_m_30 = 0;
          	   int i_chk3_p_30 = 0;
          		
          	   int i_chk4 = 0;	
          	   int i_chk4_m_30 = 0;
          	   int i_chk4_p_30 = 0;
          	   	
          	   int i_f_30 = 0;
          	   int i_t_30 = 0;
          	                       	   
          	   String  s_maint_end_dt = "";
         
          	   String  ba_dt = "";
          	   String  real_dt = "";
          	   String s_car_kd_nm ="";
          	   String s_car_use_nm ="";
          	   
				for(int i = 0 ; i < cmls.size() ; i++){
					Hashtable cml = (Hashtable)cmls.elementAt(i); 
					
					s_car_kd_nm = c_db.getNameByIdCode("0041", "", String.valueOf(cml.get("CAR_KD")));
					
					if(String.valueOf(cml.get("CAR_USE")).equals("1")){
						s_car_use_nm = "��Ʈ";
					} else if(String.valueOf(cml.get("CAR_USE")).equals("2")){
						s_car_use_nm = "����";
					}
									
					%>
                <tr> 
                	<td align="center"><% if(!cml.get("M1_CHK").equals("1") && !cml.get("M1_CHK").equals("2") && !cml.get("M1_CHK").equals("3") && !cml.get("M1_CHK").equals("5")  && !cml.get("M1_CHK").equals("6") && !cml.get("M1_CHK").equals("8") ) {%><input type='checkbox' name='multireg' value='<%=cml.get("MNG_ID")%>^<%=cml.get("CAR_MNG_ID")%>^<%=cml.get("CAR_NO")%>^<%=cml.get("RENT_L_CD")%>^<%=cml.get("RENT_MNG_ID")%>'><%}%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>>                  
                    <a class=index1 href="javascript:MM_openBrWindow('car_req_master.jsp?mng_id=<%=cml.get("MNG_ID")%>&c_id=<%=cml.get("CAR_MNG_ID")%>&car_no=<%=cml.get("CAR_NO")%>&l_cd=<%=cml.get("RENT_L_CD")%>&m_id=<%=cml.get("RENT_MNG_ID")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=620,height=350,left=50, top=50')">
                    <%= i+1 %></a></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>>
                    	<a href="javascript:view_client('<%=cml.get("RENT_MNG_ID")%>','<%=cml.get("RENT_L_CD")%>','<%=cml.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true">
                    	<%if(!String.valueOf(cml.get("RRM")).equals("0")){%><b>(��)&nbsp;</b><%} %><%= cml.get("FIRM_NM") %>
        			<%if(!String.valueOf(cml.get("CONT_DT")).equals("")){%>:��������
        			<%}else{%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("1")){%>:�Ű�����<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("3")){%>:�����<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("5")){%>:����<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("6")){%>:�Ű�<%}%>			  			  			  
        			<%}%>  
        		</a>     		
        			</td>
        			
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>><span title='<%=s_car_kd_nm%>:<%=s_car_use_nm%>'>
                    <% if ( cml.get("M1_CHK").equals("1") || cml.get("M1_CHK").equals("5")  || cml.get("M1_CHK").equals("6") || cml.get("M1_CHK").equals("8")  ) { %><font color=red><%}else if ( cml.get("M1_CHK").equals("A") ) { %><font color=green><%}else if ( cml.get("M1_CHK").equals("2") ) { %><font color=blue><%}else if ( cml.get("M1_CHK").equals("3") ) { %><font color=#ba03fe><%}%><%= cml.get("CAR_NO") %><% if ( cml.get("M1_CHK").equals("1")  || cml.get("M1_CHK").equals("2") || cml.get("M1_CHK").equals("3") || cml.get("M1_CHK").equals("5") || cml.get("M1_CHK").equals("6")  || cml.get("M1_CHK").equals("8") || cml.get("M1_CHK").equals("A") ) {%></font><% } %>
                    </span>
           <!--         <a href="javascript:MM_openBrWindow('/fms2/car_board/car_board_frame.jsp?car_mng_id=<%=String.valueOf(cml.get("CAR_MNG_ID"))%>&m_id=<%=String.valueOf(cml.get("RENT_L_CD"))%>&l_cd=<%=String.valueOf(cml.get("RENT_L_CD"))%>&gubun=MA','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a> -->
                    	  <a href="javascript:cus_pre_c('<%=cml.get("CAR_MNG_ID")%>', '<%=cml.get("CAR_NO")%>',  '<%=cml.get("RENT_MNG_ID")%>' ,  '<%=cml.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='Ư�̻���'><img src=/acar/images/center/icon_memo.gif align=absmiddle border=0></a>
                    </td>
                     <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>>
                     <% if(!cml.get("M1_CHK").equals("1") && !cml.get("M1_CHK").equals("2") && !cml.get("M1_CHK").equals("3") && !cml.get("M1_CHK").equals("5")  && !cml.get("M1_CHK").equals("6") && !cml.get("M1_CHK").equals("8") && !cml.get("M1_CHK").equals("A") ) {%>
                    &nbsp;<% } else { %><%=cml.get("M1_DT")%><%}%></td>
                     <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>><%= cml.get("CAR_NM") %></td>
                 <!--    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ) out.print("style='background-color:fff799;'"); %>><%= cml.get("RENT_WAY") %></td> -->
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>>
						<a href="javascript:view_car('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ�����ϳ���'>
							<%= AddUtil.ChangeDate2((String)cml.get("INIT_REG_DT")) %>
						</a>
					</td>
					
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)    ) out.print("style='background-color:fff799;'"); %>><%= AddUtil.ChangeDate2((String)cml.get("RENT_END_DT")) %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%=c_db.getNameByIdCode("0032", "", String.valueOf(cml.get("CAR_EXT")))%></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>>
        <%
        			s_car_kd  = String.valueOf(cml.get("CAR_KD")); //�¿���, ������ �� ����
        			s_car_use = String.valueOf(cml.get("CAR_USE"));  //�����, ������
        		//	s_car_use1 = String.valueOf(cml.get("CAR_USE1"));  //�뵵���� check
        			s_init_reg_dt = String.valueOf(cml.get("INIT_REG_DT"));  //���ʵ����
        			s_car_ext = String.valueOf(cml.get("CAR_EXT"));  //����  
        			//������ ����(test_end_dt)�� 20131118�� ���Ĵ� ���˸����� -20131218
        		//	s_gubun = "";
        			s_maint_end_dt = String.valueOf(cml.get("MAINT_END_DT")); //�˻���ȿ�Ⱓ ������
        			        		        		       			
        			real_dt = s_maint_end_dt;
        			
        			ba_dt = s_maint_end_dt.substring(0,4) + s_init_reg_dt.substring(4,8);
        			if (AddUtil.parseInt(ba_dt) < AddUtil.parseInt( s_maint_end_dt )) {
	        			ba_dt = s_maint_end_dt.substring(0,4) + s_init_reg_dt.substring(4,8);
       					real_dt = ba_dt;
       				}
					
        			//����� - '��'�� �ϴ� ����
        			if ( s_car_use.equals("1")) {
        			      				         					
        				i_chk1= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,24), -1));
        				i_chk2= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,36), -1));
        				i_chk3= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        				i_chk4= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,72), -1)); //���������� ���  8����� 1��˻� ���� 6�������� �˻� 
        				        								
        				i_chk2_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), -60));
        				i_chk2_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), 60));
        						
        				i_chk3_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), -60));
        				i_chk3_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), 60));
        				
        				i_chk4_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk4), -60));
        				i_chk4_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk4), 60));
        			       			      				
        															
	        			if (s_car_ext.equals("2") ||  s_car_ext.equals("6")  ||  s_car_ext.equals("7") )  { //���� ,  ��õ�� ���� ����
	        				    s_gubun = "����";
	        		
	        				     if (  AddUtil.getDate2(4) > i_chk3) {          				  		   
	        					   s_gubun = "����";
	        				      } else if (  AddUtil.getDate2(4) > i_chk2 && AddUtil.getDate2(4) <= i_chk3 ) {
	        					   if (  AddUtil.getDate2(4) > i_chk3_m_30 && AddUtil.getDate2(4) < i_chk3_p_30  ) {        				
	        					           s_gubun = "����";   
	        					   } else {
	        					   	 s_gubun = "����";   
	        					   }
	        				      } else if (  AddUtil.getDate2(4) > i_chk1 && AddUtil.getDate2(4) <= i_chk2 ) {
	        					    if (  AddUtil.getDate2(4) > i_chk2_m_30 && AddUtil.getDate2(4) < i_chk2_p_30  ) {
	        					         s_gubun = "����";   
	        					   } else {
	        					   	 s_gubun = "����";   
	        					   } 
	        				      } else if (  AddUtil.getDate2(4) <= i_chk1 ) {
	        					   s_gubun = "����";
	        				      }		        					
	        				      					
	        			} else {  //������õ�� �ƴϸ�
	        			    	    s_gubun = "����";
		        			
		        					if (  AddUtil.getDate2(4) > i_chk3 ) {
		        					   s_gubun = "����+����";
		        					} else if (  AddUtil.getDate2(4) > i_chk2 && AddUtil.getDate2(4) <= i_chk3 ) {
		        					   if (  AddUtil.getDate2(4) > i_chk3_m_30 && AddUtil.getDate2(4) < i_chk3_p_30  ) {
		        					     s_gubun = "����+����";   
		        					   } else {
		        					   	 s_gubun = "����+����";   
		        					   }
		        					} else if (  AddUtil.getDate2(4) > i_chk1 && AddUtil.getDate2(4) <= i_chk2 ) {
		        					    if (  AddUtil.getDate2(4) > i_chk2_m_30 && AddUtil.getDate2(4) < i_chk2_p_30  ) {
		        					     s_gubun = "����+����";   
		        					   } else {
		        					   	 s_gubun = "����";   
		        					   } 
		        					} else if (  AddUtil.getDate2(4) <= i_chk1 ) {
		        					   s_gubun = "����";
		        					}		        					
		        				
	        			 }
        			}else {   //����
        			
        			  //�¿��� - ����ȭ�� : s_car_kd :8 , s_car_kd:4 �������� 
        				if ( s_car_kd.equals("1") || s_car_kd.equals("2") || s_car_kd.equals("3") || s_car_kd.equals("9") ) { //�¿��� 
        					i_chk1= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        					i_chk2= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,72), -1));
        					        					        					
        				} else {
        					i_chk1= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,12), -1));
        					i_chk2= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        					
        					if ( s_car_kd.equals("8") ) { 
        						i_chk3= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,60), -1));
        					} else if ( s_car_kd.equals("4") ) {
        						i_chk3= AddUtil.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,96), -1));
        					}
        				} 
        				
        				i_chk2_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), -60));
        				i_chk2_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk2), 60));
        				
        				if ( s_car_kd.equals("8") ) { 
	        				i_chk3_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), -60));
	        				i_chk3_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), 60));
        				} else if ( s_car_kd.equals("4") ) {
        					 i_chk3_m_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), -96));
	        				i_chk3_p_30 = AddUtil.parseInt(c_db.addDay( Integer.toString(i_chk3), 96));
        				}
        				         				        			        			     			       			
        				if (s_car_ext.equals("2")|| s_car_ext.equals("6")|| s_car_ext.equals("7"))  { //���� , ��õ�� ���� ����
        				   	if (  AddUtil.getDate2(4) > i_chk2) {
        					   s_gubun = "����";
        					}else if (  AddUtil.getDate2(4) > i_chk1) {
        					   s_gubun = "����";
        					} else if (  AddUtil.getDate2(4) <= i_chk1 ) {
	        				   s_gubun = "����";
	        				} 
        				} else { //����, ��õ�� �ƴϸ�
        				   	if (  AddUtil.getDate2(4) > i_chk2 ) {
	        				   s_gubun = "����+����";
	        				} else if (  AddUtil.getDate2(4) > i_chk1 && AddUtil.getDate2(4) <= i_chk2 ) {
	        				    if (  AddUtil.getDate2(4) > i_chk2_m_30 && AddUtil.getDate2(4) < i_chk2_p_30  ) {
	        				     s_gubun = "����+����";   
	        				   } else {
	        				   	 s_gubun = "����";   
	        				   } 
	        				} else if (  AddUtil.getDate2(4) <= i_chk1 ) {
	        				   s_gubun = "����";
	        				}
        					
        				}
        					
        			}    
        		
        %>            
                   <%=s_gubun%>
                    </td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%= cml.get("MAINT_ST_DT") %>~<%= cml.get("MAINT_END_DT") %></td>
					<td align="center">
						<a href="javascript:view_email('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ��� ����˻� �ȳ� ����'><img src=/acar/images/center/e_mail.gif align=absmiddle border=0></a>
					</td>
        			<td align="center">
						<a href="javascript:view_sms('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>', '<%=cml.get("CAR_NO")%>')" onMouseOver="window.status=''; return true" title='�ڵ��� ����˻� �ȳ� ����'><img src=/acar/images/center/icon_tel.gif align=absmiddle border=0></a>
					</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%= c_db.addDay(real_dt,-30) %>~<%= c_db.addDay(real_dt,30) %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ) out.print("style='background-color:fff799;'"); %>><%= c_db.getNameById((String)cml.get("MNG_ID"),"USER") %>
                 
        			</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)      ) out.print("style='background-color:fff799;'"); %>><a href="javascript:go_cus_reg_maint('<%= cml.get("CAR_NO") %>')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)     ) out.print("style='background-color:fff799;'"); %>><%= cml.get("CAR_DOC_NO") %></td>			
                </tr>
          <% 	}
		  	}else{ %>
                <tr> 
                    <td colspan="17" align="center">������ ���� / ���а˻� ������ �����ϴ�.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
    <tr> 
        <td><a name='3'></a></td>
    </tr>  

</table>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
