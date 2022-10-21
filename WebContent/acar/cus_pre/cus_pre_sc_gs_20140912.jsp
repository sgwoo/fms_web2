<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*, acar.accid.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	if  ( !user_nm.equals("��ü") ) {
		Hashtable id = c_db.getDamdang_id(user_nm);
		user_id = String.valueOf(id.get("USER_ID"));
	} else {
	          user_id = "";
	}

	CusPre_Database cp_db = CusPre_Database.getInstance();
	
	Vector cmls = cp_db.getCar_maintList(user_id, s_kd, t_wd);
				

	//���������� ���ɸ��Ό��
	Vector vt3 = ad_db.getCarEndDtEstList(user_id);
	int vt_size3 = vt3.size();
	

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

		fm.action='/acar/accid_mng/accid_u_frame.jsp'
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

	function serv_action(car_mng_id, serv_id, accid_id){
		var fm = document.form1;
		var SUBWIN="/acar/cus_reg/serv_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id+"&from_page=/acar/cus_pre/cus_pre_sc_gs.jsp"; 
		window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=720,top=50,left=50');
	}
-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
        	   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* �����ڵ��������� �켱 �����մϴ�. ������ �����Ĵ�� �������ּ���!!!!</font> 
       
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
                    <td width='18%' class='title'>��ȣ</td>
                    <td width='11%' class='title'>�뿩������</td>
                    <td width='11%' class='title'>������ȣ</td>
                    <td width='15%' class='title'>����</td>
                    <td width='7%' class='title'>��ⷮ</td>
                    <td width='10%' class='title'>�����</td>
                    <td width='10%' class='title'>���ɸ�����</td>
				<!--	<td width='8%' class='title'>�����Ȳ</td> -->
					<td width='8%' class='title'>�����Ȳ</td>
                    <td width='7%' class='title'>�������</td>
                </tr>
          <%if(vt_size3 > 0){
				for (int i = 0 ; i < vt_size3 ; i++){
					Hashtable ht = (Hashtable)vt3.elementAt(i);%>
                <tr>
                    <td align="center">
                     <span title=�Ƿ���:<%=ht.get("M1_DT")%>>
                    <a class=index1  href="javascript:MM_openBrWindow('car_req_master.jsp?gubun=Y&mng_id=<%=ht.get("BUS_ID2")%>&c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>&l_cd=<%=ht.get("RENT_L_CD")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=520,height=250,left=50, top=50')"> 
                                <%=i+1%></a></span></td>            
                    <td align="center"><%if(String.valueOf(ht.get("RRM")).equals("0")){%><b>(��)</b><%} %>&nbsp;<%= ht.get("FIRM_NM") %></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td align="center">
                      <% if ( ht.get("M1_CHK").equals("3") ) { %><font color=#ba03fe><%}%><%= ht.get("CAR_NO") %><% if ( ht.get("M1_CHK").equals("3")  ) {%></font><% } %>
                      </td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    <td align="center"><%=ht.get("DPM")%>cc</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_CAR_END_DT")))%></td>
				<!--	<td align="center"><%if(ht.get("DG_YN").equals("Y")){%>ó���Ϸ�<%}else if(ht.get("DG_YN").equals("N")){%><a href="javascript:dg_input('<%=ht.get("DG_NO")%>')">����߼�</a><%}else{%><%}%></td> -->
					<td align="center">
						<%if(ht.get("OFF_LS").equals("5")){%>����
					<!--	<%//}else if(ht.get("OFF_LS").equals("1")){%>�Ű����� -->
						<%}else if(ht.get("OFF_LS").equals("3")){%>�����
						<%}else if(ht.get("OFF_LS").equals("6")){%>�Ű�
						<%}%></td>
                    <td align="center"><%=ht.get("USER_NM")%></td>          
		        </tr>
          <%  }
			}else{%>
                <tr>
                    <td colspan="10" align="center">�ڷᰡ �����ϴ�.</td>
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
        <td>&nbsp;&nbsp;&nbsp;* �˻���ȿ�Ⱓ/������ȿ�Ⱓ���� �����˻簡 �̷������ ���� �������� �ϸ�, �˻�Ⱓ�� ���ʵ������ �������� �����մϴ�.
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������ �˻�Ⱓ ��/�ĸ� ������ �˻��� ��� ��¥ ���̰� �߻��Ǵ� �����ϼż� �˻�Ⱓ üũ�Ͻ� �� �����ϼž� �մϴ�. 
               <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ȭ��, ����  5���̻��� 6�������� ����, 1����� �����̹Ƿ� <font color=red>����</font>�� Ȯ���ϼž� �մϴ�. 
        	   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* ����Ÿ�ڵ���/�����ڵ����� �˻������ �Ƿ��� ��쿡�� �ش� ������ ������ �� �Ƿڵ�ϸ� �����Ͽ� �����ϼ���.!!</font> 
        	   <br>&nbsp;&nbsp;&nbsp;<font color="blue">* ����Ÿ/�ϵ�����Ź�۹����� �Ƿڵ� ������ ������ȣ�� </font><font color=red>����</font><font color=blue>,������ �Ƿڵ� ������ ������ȣ�� <font color=#ba03fe>�����</font><font color=blue>���� ǥ�õ˴ϴ�!!
        	   <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����, �˻��Ƿ� ��û�� �Ƹ���ī�� ����Ÿ/�����ڵ����� ���� �����ϰ� ��ó���� �� �� �ֵ��� ����� �����ð��� �ΰ� ó���ϼž� �մϴ�.</font>
        	   <br>&nbsp;&nbsp;&nbsp;* ����ڰ� ���� �˻縦 �ϰڴٰ� ������ ��� ������ȣ�� <font color=blue><b>�Ķ���</b></font> ���� ǥ�� �˴ϴ�.
        	   <br>&nbsp;&nbsp;&nbsp;<font color=red>* ���¾�ü�� ��Ź�Ͽ� �˻簡 �Ϸ�� ���� ���� ���ϳ��� ����ڰ� �ݵ�� �˻����� �ϼž� �մϴ�. �˻�Ⱓ �絵���� ������ ���� �� �ֽ��ϴ�.</font>  
        	   <br>&nbsp;&nbsp;&nbsp;<font color=red>* ���������Ͽ� ���� ���˱�Ϻ� �˻���ȿ�Ⱓ�� 3���� ��찡 �ֽ��ϴ�. �������� Ȯ���ϼż� �ڵ������� �����ϼž� �մϴ�.
			   <br>&nbsp;&nbsp;&nbsp;<font color=red>* ����(<img src=/acar/images/center/e_mail.gif align=absmiddle border=0>) �������� Ŭ���Ͻø� ���� ���ۿ��θ� �����Ͻ� �� �ֽ��ϴ�. [Ȯ��]��ư�� ����/[���]��ư�� ������ �Դϴ�.</font>  
			   </font>  
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%"  class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=3% >����</td>
                    <td class=title width=12%>��ȣ</td>
                    <td class=title width=7% >������ȣ</td>
                    <td class=title width=4% >����<br>����</td>
                    <td class=title width=7% >���ʵ����</td>
                    <td class=title width=7% >��ุ����</td>
                    <td class=title width=4% >���<br>����</td>
            <!--          <td class=title width="75" rowspan="2">����������</td> -->
                    <td class=title width=6% >�׸�</td>
                    <td class=title width=11% >�˻���ȿ�Ⱓ</td>    
                    <td class=title width=3% >����</td>
                    <td class=title width=11% >������ȿ�Ⱓ</td>                    
                    <td class=title width=11% >�˻�Ⱓ</td>
                    <td class=title width=4% >����<br>���</td>
                    <td class=title width=4% >���</td>
                    <td class=title width=9% >����<br>��ȣ</td>			
                </tr>
              
          <%if(cmls.size() > 0){
          	
          	   String s_car_kd = "";
          	   String s_car_use = "";
          	   String s_car_use1 = "";
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
          	   
          	   int r_test_end_dt = 0;
          	   
          	   String  s_maint_end_dt = "";
          	   String  s_test_end_dt = "";
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
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>>
                   <span title=�Ƿ���:<%=cml.get("M1_DT")%>>
                    <a class=index1 href="javascript:MM_openBrWindow('car_req_master.jsp?mng_id=<%=cml.get("MNG_ID")%>&c_id=<%=cml.get("CAR_MNG_ID")%>&car_no=<%=cml.get("CAR_NO")%>&l_cd=<%=cml.get("RENT_L_CD")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=520,height=250,left=50, top=50')">
                    <%= i+1 %></a></span></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)   ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>>
                    	<a href="javascript:view_client('<%=cml.get("RENT_MNG_ID")%>','<%=cml.get("RENT_L_CD")%>','<%=cml.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true">
                    	<%if(!String.valueOf(cml.get("RRM")).equals("0")){%><b>(��)</b><%} %>&nbsp;<%= cml.get("FIRM_NM") %>
        			<%if(!String.valueOf(cml.get("CONT_DT")).equals("")){%>:��������
        			<%}else{%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("1")){%>:�Ű�����<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("3")){%>:�����<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("5")){%>:����<%}%>
        			  <%if(String.valueOf(cml.get("OFF_LS")).equals("6")){%>:�Ű�<%}%>			  			  			  
        			<%}%>  
        		</a>     		
        			</td>
        			
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  ) ) out.print("style='background-color:fff799;'"); %>><span title='<%=s_car_kd_nm%>:<%=s_car_use_nm%>'>
                    <% if ( cml.get("M1_CHK").equals("1") || cml.get("M1_CHK").equals("5")  ) { %><font color=red><%}else if ( cml.get("M1_CHK").equals("2") ) { %><font color=blue><%}else if ( cml.get("M1_CHK").equals("3") ) { %><font color=#ba03fe><%}%><%= cml.get("CAR_NO") %><% if ( cml.get("M1_CHK").equals("1")  || cml.get("M1_CHK").equals("2") || cml.get("M1_CHK").equals("3") || cml.get("M1_CHK").equals("5") ) {%></font><% } %>
                    </span></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  ) ) out.print("style='background-color:fff799;'"); %>><%= cml.get("RENT_WAY") %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  ) ) out.print("style='background-color:fff799;'"); %>>
						<a href="javascript:view_car('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ�����ϳ���'>
							<%= AddUtil.ChangeDate2((String)cml.get("INIT_REG_DT")) %>
						</a>
					</td>
					
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  ) ) out.print("style='background-color:fff799;'"); %>><%= AddUtil.ChangeDate2((String)cml.get("RENT_END_DT")) %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  ) ) out.print("style='background-color:fff799;'"); %>>
        			 <%=c_db.getNameByIdCode("0032", "", String.valueOf(cml.get("CAR_EXT")))%>
                    </td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  ) ) out.print("style='background-color:fff799;'"); %>>
        <%
        			s_car_kd  = String.valueOf(cml.get("CAR_KD")); //�¿���, ������ �� ����
        			s_car_use = String.valueOf(cml.get("CAR_USE"));  //�����, ������
        			s_car_use1 = String.valueOf(cml.get("CAR_USE1"));  //�뵵���� check
        			s_init_reg_dt = String.valueOf(cml.get("INIT_REG_DT"));  //���ʵ����
        			s_car_ext = String.valueOf(cml.get("CAR_EXT"));  //����  
        			//������ ����(test_end_dt)�� 20131118�� ���Ĵ� ���˸����� -20131218
        		//	s_gubun = "";
        			s_maint_end_dt = String.valueOf(cml.get("MAINT_END_DT")); //�˻���ȿ�Ⱓ ������
        			        		        		       			
        			real_dt = s_maint_end_dt;
        			
        			ba_dt = s_maint_end_dt.substring(0,4) + s_init_reg_dt.substring(4,8);
        			if (Integer.parseInt(ba_dt) < Integer.parseInt( s_maint_end_dt )) {
	        			ba_dt = s_maint_end_dt.substring(0,4) + s_init_reg_dt.substring(4,8);
       					real_dt = ba_dt;
       				}
					
        			//����� - '��'�� �ϴ� ����
        			if ( s_car_use.equals("1")) {
        				
        				s_test_end_dt = String.valueOf(cml.get("TEST_END_DT"));  //������ȿ�Ⱓ ������ - ����
        			
        				r_test_end_dt  = AddUtil.parseInt(s_test_end_dt);  //��������ȿ�Ⱓ ������ - ����
        				i_chk4 = AddUtil.parseInt(s_test_end_dt);  //������ȿ�Ⱓ ������ - ����
        				
        				if ( i_chk4 > 20131118 )  i_chk4 = 29991231;    				 
        				        				         					
        				i_chk1= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,24), -1));
        				i_chk2= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,36), -1));
        				i_chk3= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        				        								
        				i_chk2_m_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk2), -60));
        				i_chk2_p_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk2), 60));
        						
        				i_chk3_m_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk3), -60));
        				i_chk3_p_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk3), 60));
        				
        				i_chk4_m_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk4), -60));
        				i_chk4_p_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk4), 60));
        				
        															
	        			if (s_car_ext.equals("2") || s_car_ext.equals("6") || s_car_ext.equals("7"))  { //���� , ��õ, ��õ�� ���� ����
	        				    s_gubun = "����";
	        				    if ( r_test_end_dt > 20131118 ) {
	        				    }  else {
		        				     if (  AddUtil.getDate2(4) > i_chk3) {          				  		   
		        					   s_gubun = "����+����";
		        				      } else if (  AddUtil.getDate2(4) > i_chk2 && AddUtil.getDate2(4) <= i_chk3 ) {
		        					   if (  AddUtil.getDate2(4) > i_chk3_m_30 && AddUtil.getDate2(4) < i_chk3_p_30  ) {        				
		        					           s_gubun = "����+����";   
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
		        					
		        			       	// ���������� �ٽ� check
		        					 if (  AddUtil.getDate2(4) > i_chk4) {          				  		   
		        					   s_gubun = "����+����";
		        					 } else if (  AddUtil.getDate2(4) > i_chk4_m_30 && AddUtil.getDate2(4) < i_chk4_p_30  ) {        				
		        					     s_gubun = "����+����";   
		        					 }				
	        				   }
	        				      					
	        			    } else {  //������õ�� �ƴϸ�
	        			    	        s_gubun = "����";
		        			        if ( r_test_end_dt > 20131118 ) {
		        			         }  else {
		        					if (  AddUtil.getDate2(4) > i_chk3 ) {
		        					   s_gubun = "����+����+����";
		        					} else if (  AddUtil.getDate2(4) > i_chk2 && AddUtil.getDate2(4) <= i_chk3 ) {
		        					   if (  AddUtil.getDate2(4) > i_chk3_m_30 && AddUtil.getDate2(4) < i_chk3_p_30  ) {
		        					     s_gubun = "����+����+����";   
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
		        					
		        					// ���������� �ٽ� check - 20110125
		        					 if (  AddUtil.getDate2(4) > i_chk4) {          				  		   
		        					   s_gubun = "����+����+����";
		        					 } else if (  AddUtil.getDate2(4) > i_chk4_m_30 && AddUtil.getDate2(4) < i_chk4_p_30  ) {        				
		        					     s_gubun = "����+����+����";   
		        					 }
	        				      }
	        			 }
        			}else {   //����
        			
        			  //�¿��� - ����ȭ�� : s_car_kd :8
        				if ( s_car_kd.equals("1") || s_car_kd.equals("2") || s_car_kd.equals("3") || s_car_kd.equals("9") ) {
        					i_chk1= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        					i_chk2= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,72), -1));
        					        					        					
        				} else {
        					i_chk1= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,12), -1));
        					i_chk2= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,48), -1));
        					
        					if ( s_car_kd.equals("8") ) { 
        						i_chk3= Integer.parseInt( c_db.addDay(c_db.addMonth(s_init_reg_dt,60), -1));
        					}
        				} 
        				
        				i_chk2_m_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk2), -60));
        				i_chk2_p_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk2), 60));
        				
        				if ( s_car_kd.equals("8") ) { 
	        				i_chk3_m_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk3), -60));
	        				i_chk3_p_30 = Integer.parseInt(c_db.addDay( Integer.toString(i_chk3), 60));
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
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>><%= cml.get("MAINT_ST_DT") %>~<%= cml.get("MAINT_END_DT") %></td>
					<td align="center">
						<a href="javascript:view_email('<%=cml.get("RENT_MNG_ID")%>', '<%=cml.get("RENT_L_CD")%>', '<%=cml.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='�ڵ��� ����˻� �ȳ� ����'><img src=/acar/images/center/e_mail.gif align=absmiddle border=0></a>
					</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>><%= cml.get("TEST_ST_DT") %>~<%= cml.get("TEST_END_DT") %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>><%= c_db.addDay(real_dt,-30) %>~<%= c_db.addDay(real_dt,30) %></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>><%= c_db.getNameById((String)cml.get("MNG_ID"),"USER") %>
                 	<!--    <a href="javascript:MM_openBrWindow('cus_pre_sc_gs_sms.jsp?gs_s_dt=<%= c_db.addDay(real_dt,-30) %>&gs_e_dt=<%= c_db.addDay(real_dt,30) %>&user_id=<%=user_id%>&car_no=<%= cml.get("CAR_NO") %>&rent_l_cd=<%= cml.get("RENT_L_CD") %>','list_id2','scrollbars=yes,status=no,resizable=yes,width=550,height=400,top=50,left=50')"><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0" alt="���ں�����"></a>	-->
        			</td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>><a href="javascript:go_cus_reg_maint('<%= cml.get("CAR_NO") %>')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center" <% if(AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("MAINT_END_DT")))<=(AddUtil.getDate2(4)-7)  ||  (   String.valueOf(cml.get("CAR_USE")).equals("1")  &&  AddUtil.ChangeStringInt(AddUtil.ChangeDate2((String)cml.get("TEST_END_DT")))<=(AddUtil.getDate2(4)-7)  )  ) out.print("style='background-color:fff799;'"); %>><%= cml.get("CAR_DOC_NO") %></td>			
                </tr>
          <% 	}
		  	}else{ %>
                <tr> 
                    <td colspan="16" align="center">������ ���� / ���а˻� ������ �����ϴ�.</td>
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
