<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*,acar.insur.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.accid.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>


<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String ch_cd[] = request.getParameterValues("ch_cd");
	String user_type 	= request.getParameter("user_type")==null?"":request.getParameter("user_type");
	String user_name 	= request.getParameter("user_name")==null?"":request.getParameter("user_name");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mail_yn = request.getParameter("mail_yn")	==null? "":request.getParameter("mail_yn");
	
	int vid_size 		= 0;
	
	vid_size = ch_cd.length;
	
	UsersBean ins_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ꺸����"));
	
	String r_fee_est_dt="";
	
	
	String rent_mng_id = "";
	String rent_l_cd = "";
	
	int amt_comp = 0;
	String item = "";
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
    font-family: "���� ���", Malgun Gothic, "����", gulim,"����", dotum, arial, helvetica, sans-serif;
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
    border: 1px #888 solid ;
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
        margin: 0 !important; 
      	padding: 0 !important;
      	overflow: hidden;
    }
.paper {
    margin: 0;
    border: initial;
    border-radius: initial;
    width: initial;
    min-height: initial;
    box-shadow: initial;
    background: initial;
    page-break-after: auto;
}

}
table {
    border-collapse: collapse;
}

table, th, td {
    border: 1px solid black;
}

</style>

</head>
<body >
<object id="factory" style="display:none" > 
</object> 
<form action="" name="form1" method="POST" >
    <div class="paper">
        <div class="content">
        	<div id="top" style="  "><!-- ��ü ���� �� ��ܺ���   -->
	        		<div id="title" align="center" style="padding:20px;"> 
	        			<p style="margin:0px;display:inline-block;font-size:18pt;border-bottom-style: double;">�ڵ������� ������ ���� ��û��</p>
	        		</div>
	        		<div style="text-align:right;">
	        			<p style="margin:0px;display:inline-block;">�ֽ�ȸ�� �Ƹ���ī ����</p>
	        		</div>
        	</div>
    		<div id="container" style="background-color:white;"> <!-- ��ü ���� �� �߾Ӻ���  -->
    			<div id="con1">
    				<div id="con1Title">
    					<p style="font-size:11pt;display:inline-block;padding:0px 0px 0px 20px;margin-bottom: 5px;">�� ���� ��û�� ����</p>
    				</div>
    				<table width="610" height="30" align="center" >
		                <tr align="center"> 
		                    <td style="font-size : 11pt;" width="20%">������ȣ</td>
		                    <td style="font-size : 11pt;" width="20%">����</td>
		                    <td style="font-size : 11pt;" width="20%">���汸��</td>
		                    <td style="font-size : 11pt;" width="20%">������</td>
		                    <td style="font-size : 11pt;" width="20%">������</td>			
		                </tr>
                        <%	 	
                        	String ch_after = "";
                        	for(int i=0;i < vid_size;i++){
            				//���躯��
            				InsurChangeBean d_bean = ins_db.getInsChangeDoc(ch_cd[i]);
            					
            				//���躯�渮��Ʈ
            				Vector ins_cha = ins_db.getInsChangeDocList(ch_cd[i]);
            				int ins_cha_size = ins_cha.size();
            					
            				//�����ȸ
            				Hashtable cont = as_db.getRentCase(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
            				
            				rent_mng_id = d_bean.getRent_mng_id();
            				rent_l_cd =  d_bean.getRent_l_cd();
            				
            				//��������
            				ins = ins_db.getInsCase((String)cont.get("CAR_MNG_ID"), d_bean.getIns_st());
            				//System.out.println(ins.getCar_use());
            				
            				r_fee_est_dt = String.valueOf(d_bean.getR_fee_est_dt());
            				
            				int cont_dis = 0;
            				int fee_cng = 0;
            				if(d_bean.getD_fee_amt()>0 || d_bean.getD_fee_amt()<0) fee_cng = 1;
		                %>
		                
						<tr bgcolor="#FFFFFF" align="center"  height="30">
						    <td style="font-size : 11pt;" width="20%" <%if(ins_cha_size+fee_cng>1){%>rowspan='<%=ins_cha_size+fee_cng%>'<%}%>><%=cont.get("CAR_NO")%><%if(ins_cha_size>1){%><br>(<%=ins_cha_size%>��)<%}%></td>
						    <td style="font-size : 11pt;" width="20%" <%if(ins_cha_size+fee_cng>1){%>rowspan='<%=ins_cha_size+fee_cng%>'<%}%>><%=cont.get("CAR_NM")%></td>
						    <%	for(int j = 0 ; j < 1 ; j++){
									InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);%>
						    <td style="font-size : 10pt;" width="20%" >
							<%if(cha.getCh_item().equals("10")){%>����2���Աݾ�<%}%>
							<%if(cha.getCh_item().equals("1")){%>�빰���Աݾ�<%}%>
							<%if(cha.getCh_item().equals("2")){%>�ڱ��ü����Աݾ�(���/���)<%}%>
							<%if(cha.getCh_item().equals("12")){%>�ڱ��ü����Աݾ�(�λ�)<%}%>
							<%if(cha.getCh_item().equals("7")){%>�빰+�ڱ��ü����Աݾ�<%}%>
							<%if(cha.getCh_item().equals("3")){%>������������Ư��<%}%>
							<%if(cha.getCh_item().equals("4")){%>�ڱ��������ذ��Աݾ�<%}%>
							<%if(cha.getCh_item().equals("9")){%>�ڱ����������ڱ�δ��<%}%>
							<%if(cha.getCh_item().equals("5")){%>���ɺ���<% item = "���ɺ���";}%>
							<%if(cha.getCh_item().equals("6")){%>�ִ�īƯ��<%}%>
							<%if(cha.getCh_item().equals("8")){%>��������<%}%>
							<%if(cha.getCh_item().equals("11")){%>������ü<%}%>
							<%if(cha.getCh_item().equals("13")){%>��Ÿ<%}%>
							<%if(cha.getCh_item().equals("14")){%>��������������Ư��<%}%>
							<%if(cha.getCh_item().equals("15")){%>�Ǻ����ں���<%}%>
							<%if(cha.getCh_item().equals("16")){%>���Ǻ����� ���谻��<%}%>
							<%if(cha.getCh_item().equals("17")){%>���ڽ�<%}%>
							<%if(cha.getCh_item().equals("18")){%>���ΰ�<%}%>
		   					</td>
						    <td style="font-size : 10pt;" width="20%">
						    	<%if(cha.getCh_item().equals("5") && (cha.getCh_before().equals("21���̻�")||cha.getCh_before().equals("24���̻�")||cha.getCh_before().equals("26���̻�")||cha.getCh_before().equals("30���̻�")||cha.getCh_before().equals("35���̻�")||cha.getCh_before().equals("43���̻�")||cha.getCh_before().equals("48���̻�"))){%>
						    	��<%=cha.getCh_before()%>
						    	<%}else{%>
						    	<%=cha.getCh_before()%>
						    	<%}%>
						    	
						    </td>
						    <td style="font-size : 10pt;" width="20%">
						    	<% ch_after = cha.getCh_after();%> 
						    	<%if(cha.getCh_item().equals("5") && (cha.getCh_after().equals("21���̻�")||cha.getCh_after().equals("24���̻�")||cha.getCh_after().equals("26���̻�")||cha.getCh_after().equals("30���̻�")||cha.getCh_after().equals("35���̻�")||cha.getCh_after().equals("43���̻�")||cha.getCh_after().equals("48���̻�"))){%>
						    	��<%=cha.getCh_after()%>
						    	<%}else{%>
						    	<%=cha.getCh_after()%>
						    	<%}%>
						    	
						    </td>
						    <%		}%>
				         </tr>
		               	<%	if(ins_cha_size>1){%>
						<%	for(int j = 1 ; j < ins_cha_size ; j++){
								InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);%>
                		<tr bgcolor="#FFFFFF" align="center"  height="30"> 
							<td style="font-size : 10pt;" width="20%" >
								<%if(cha.getCh_item().equals("10")){%>����2���Աݾ�<%}%>
								<%if(cha.getCh_item().equals("1")){%>�빰���Աݾ�<%}%>
								<%if(cha.getCh_item().equals("2")){%>�ڱ��ü����Աݾ�(���/���)<%}%>
								<%if(cha.getCh_item().equals("12")){%>�ڱ��ü����Աݾ�(�λ�)<%}%>
								<%if(cha.getCh_item().equals("7")){%>�빰+�ڱ��ü����Աݾ�<%}%>
								<%if(cha.getCh_item().equals("3")){%>������������Ư��<%}%>
								<%if(cha.getCh_item().equals("4")){%>�ڱ��������ذ��Աݾ�<%}%>
								<%if(cha.getCh_item().equals("9")){%>�ڱ����������ڱ�δ��<%}%>
								<%if(cha.getCh_item().equals("5")){%>���ɺ���<% item = "���ɺ���";}%>
								<%if(cha.getCh_item().equals("6")){%>�ִ�īƯ��<%}%>
								<%if(cha.getCh_item().equals("8")){%>��������<%}%>
								<%if(cha.getCh_item().equals("11")){%>������ü<%}%>
								<%if(cha.getCh_item().equals("13")){%>��Ÿ<%}%>
								<%if(cha.getCh_item().equals("14")){%>��������������Ư��<%}%>
								<%if(cha.getCh_item().equals("15")){%>�Ǻ����ں���<%}%>
								<%if(cha.getCh_item().equals("16")){%>���Ǻ����� ���谻��<%}%>
								<%if(cha.getCh_item().equals("17")){%>���ڽ�<%}%>
								<%if(cha.getCh_item().equals("18")){%>���ΰ�<%}%>
							</td>
					    	<td style="font-size : 10pt;" width="20%"><%=cha.getCh_before()%></td>
					  		<td style="font-size : 10pt;" width="20%"><%=cha.getCh_after()%></td>	
		                </tr>
						<%	}%>                
		                <%	}%>
		                <%	if(fee_cng>0){%>
		                <tr bgcolor="#FFFFFF" align="center"  height="30">	
						    <td style="font-size : 10pt;" width="20%" >
									�뿩��(��)
						    </td>
						    <td style="font-size : 10pt;" width="20%"><%=AddUtil.parseDecimal(d_bean.getO_fee_amt())%></td>
						    <td style="font-size : 10pt;" width="20%"><%=AddUtil.parseDecimal(d_bean.getN_fee_amt())%></td>		
						    <%
						     amt_comp = d_bean.getN_fee_amt() - d_bean.getO_fee_amt();
						    %>
						    				
		                </tr>                
		                <%	}%>
		                <% 	}%>
				      
			       	</table>	
			       	<%
			       		if(ins.getCar_use().equals("1") && ch_after.equals("21���̻�")){
			       	%>
			       	<div id="tip1">
				       	<p style="margin:2px;font-size:9pt;padding-left:40px; width:640px;">
				       		* ���� �� 21���̻� ����� ���� �����̿��ڰ� �� 26���̻� �Ǹ� �뿩�� ���ϸ� ���� ����ڿ��� �����Ͻþ� ���ɻ��� ��û�� ���ֽñ�ٶ��ϴ�
				       	</p>
			       	</div>
			       	<%
			       		}
			       	%>
    			</div>
    			<div id="con2">
    				<div id="con2Title">
    					<p style="font-size:11pt;display:inline-block;padding:0px 0px 0px 20px;margin-bottom: 5px;" >
    					�� ����Ⱓ <span  style="font-size:11pt;">(��û�� �����)</span>
    					</p>
    				</div>
    				<table width="610" align="center" >
   					   <%	
   							Hashtable f_cont = new Hashtable();
		                	for(int i=0;i < vid_size;i++){
							//���躯��
							InsurChangeBean d_bean = ins_db.getInsChangeDoc(ch_cd[i]);
								
							//���躯�渮��Ʈ
							Vector ins_cha = ins_db.getInsChangeDocList(ch_cd[i]);
							int ins_cha_size = ins_cha.size();
							
							//���⺻����
						//	ContBaseBean base = a_db.getCont(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
							
							//�����ȸ
							Hashtable cont = as_db.getRentCase(d_bean.getRent_mng_id(), d_bean.getRent_l_cd());
							
							if(i==0) f_cont = cont;
							int cont_dis = 0;
							int fee_cng = 0;
							if(d_bean.getD_fee_amt()>0 || d_bean.getD_fee_amt()<0) fee_cng = 1;
		                %>
                     	<tr bgcolor="#FFFFFF" align="center" > 
		  					<td  rowspan="2" style="font-size : 11pt;" width="150" height="20">��������</td>
		                    <td  colspan="2" style="font-size : 11pt;" height="20">��������</td>
		                    <td  rowspan="2" style="font-size : 11pt;" width="100" height="20">(����)�������ǻ���</td>		
		                </tr>
		                 <tr bgcolor="#FFFFFF" align="center"> 
		                    <td style="font-size : 11pt;" width="150" height="20">Ȯ������</td>
		                    <td style="font-size : 11pt;" width="120" height="20">����</td>		
		               	</tr>
			            <tr bgcolor="#FFFFFF" align="center"  height="100">
					    	<td style="font-size : 11pt;" rowspan=''>20&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp; &nbsp;&nbsp;&nbsp;�� <br/><br/>24��(����)</td>
					    	<td style="font-size : 11pt;" rowspan=''>20&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;�� <br/><br/>24��(����)</td>
						    <%	for(int j = 0 ; j < 1 ; j++){
									InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);%>
						    	<td style="font-size : 11pt;"  >
							
							    </td>
						   		 <td style="font-size : 10pt; padding-left:30px;" align='left' >
						    		��) ���� ĭ�� ���� �Ǵ�<br/>&nbsp;&nbsp;&nbsp;����<br/><br/>
						    		��) ���� �� ���� ��û�� <br/>&nbsp;&nbsp;&nbsp;�� ���ۼ��� �����ؾ�<br/>&nbsp;&nbsp;&nbsp;�� �մϴ�<br/>
						   		 </td>
						    <%	}%>
						</tr>
			                <%	if(ins_cha_size>1){%>
							<%		for(int j = 1 ; j < ins_cha_size ; j++){
										InsurChangeBean cha = (InsurChangeBean)ins_cha.elementAt(j);
									
							%>
							<%		}%>                
			                <%	}%>
			                <%	if(fee_cng>0){%>
			                <%	}%>
			                <% 	}%>
			       	</table>
			       		<div id="tip1">
				       	<p style="margin:2px;font-size:9pt;padding-left:40px; width:640px;">
				       		* ����Ⱓ�� ���� ��� �������ڸ� ���ʷ� �ۼ��� �ֽð�, �������� �ۼ����� ������  �� �ֽñ� �ٶ��ϴ�. 
				       	</p>
				       	<p style="margin:2px;font-size:9pt;padding-left:40px; width:640px;">
				       		* �������ڴ� �ʼ� ���� �׸� �Դϴ�.
				       	</p>
			       	</div>
			       	
    			</div>
    			<%if( item.equals("���ɺ���")  && amt_comp > 0){%>
    			
    				<div id="con3">
    				<div id="con3Title">
    					<p style="font-size:11pt;display:inline-block;padding:0px 0px 0px 20px;margin-bottom: 10px;">
    					�� �������ɿ����� <span  style="font-size:11pt;">(��û�� �����)</span></p>
    				</div>
    				<table width="610" height="60" align="center" >
						<tr bgcolor="#FFFFFF" align="center"> 
							<td style="font-size : 10pt;" width="10%">����</td>
							<td style="font-size : 10pt;" width="15%"></td>
							<td style="font-size : 10pt;" width="20%">�������</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
							<td style="font-size : 10pt;" width="15%">����ó</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
						</tr>
						 <tr bgcolor="#FFFFFF" align="center"> 
						    <td style="font-size : 10pt;" width="10%">�������</td>
							<td style="font-size : 10pt;" width="15%"></td>		
							<td style="font-size : 10pt;" width="20%">����ڿ��� ����</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
							<td style="font-size : 10pt;" width="15%">������濬��</td>		
							<td style="font-size : 10pt;" width="15%"></td>		
						</tr>
			       	</table>
			       	<div id="tip1">
				       	<p style="margin:2px;font-size:11pt;padding-left:40px; width:640px;">
				       		��û����� ����ó: 
				       	</p>
				       	<p style="margin:2px;font-size:11pt;padding-left:40px; width:640px;">
				       		��� ������ ��û�Ͻ� �������� ���� 12�ú��� ����˴ϴ�.
				       	</p>
			       	</div>
    			</div>
    			
    			<%}else{ %>
    				<div style="margin-bottom:150px;"></div>
    			<%} %>
    			<div id="con4">
					<div width="90%"  align="center" style="padding-top:0px;">
						<div>
							<p style="font-size:12pt;padding:10px;">���� ���� �������� �Ϻθ� ������ ��û�մϴ�.</p>
						</div>
						<div>
							<div style="font-size:12pt;padding:5px;">20&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</div>
						</div>
						<div align="right" style="padding:30px 40px 0px 0px;">
							<div style="font-size:12pt;display:inline-block;padding-right:250px;">�����</div>
							<div style="font-size:10pt;display:inline-block;">(����/����)</div>
						</div>
					</div>
				</div>
			</div>
	   		<div id="footer" style="padding-top:30px;"> <!-- ��ü ���� �� �ϴܺ���  -->
	   			<div id="fot1">
				<%
	   				String year = "";
	   				String mon = "";
	   				String day = "";
	   				if(r_fee_est_dt != ""){
	   					 year = r_fee_est_dt.substring(0,4);   
	   					 mon = r_fee_est_dt.substring(4,6);   
	   					 day = r_fee_est_dt.substring(6,8);
	   				}
	   			%>
	   			<p style="margin:0px;font-size:11pt;padding:3px;font-family:�ü�;">���� ��û ���� ���� 4�������� ȸ�ź�Ź�帳�ϴ�.</p>
	   			<p style="margin:0px;font-size:11pt;padding:3px;font-family:�ü�;">�� ���� ��û ���� ���� 24�ú��� ����˴ϴ�.</p>
	   			
	   			<% if(r_fee_est_dt != ""){ %>
					<p style="margin:0px;font-size:10pt;padding:3px;">���� ���������� : <%=year%>�� <%=mon%>�� <%=day%>��</p>
				<%} %>	
					<p style="margin:0px;font-size:10pt;padding:3px;">1. ���濡 ���� �뿩�� ������ �ֽ��ϴ�.</p>
					<p style="margin:0px;font-size:10pt;padding:3px;">2. �� ���� ����ڶ��� ���ǰ� ������ �����ϰ� �Ʒ� FAX�� ȸ���� �ֽʽÿ�.</p>
					<p style="margin:0px;font-size:10pt;padding:3px;">&nbsp;&nbsp;&nbsp;�������� : ���� (TEL 02-6263-6372)&nbsp;&nbsp;&nbsp;FAX(��������) : 02-6944-8451</p>
				<%
					
					//���⺻����
					ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
					String bus_id = "";
					if(user_type.equals("1")) bus_id = base.getBus_id2(); //���������
					else if(user_type.equals("2")) bus_id = base.getBus_id();	//���ʿ�����
					else if(user_type.equals("3")){ //�����
						bus_id = user_id;
					}
				
					UsersBean bus_bean 	= umd.getUsersBean(bus_id);
				%>	
					<p style="margin:0px;font-size:10pt;padding:3px;">&nbsp;&nbsp;&nbsp;��������� : <%=bus_bean.getUser_nm()%> (TEL <%=bus_bean.getUser_m_tel()%>)</p>
	   			</div>
  			</div>
    	</div>    
	</div>
</form>
</body>
</html>
<script>

</script>