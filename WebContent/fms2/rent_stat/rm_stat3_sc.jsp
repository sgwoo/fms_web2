<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String start_dt = request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector branches = c_db.getUserBranchs("rent"); 			//������ ����Ʈ
	int brch_size 	= branches.size();	
		
	//������
	int br_size = brch_size;
	
	//������
	int kd_size = 4;
	
	
	String car_kd_nm[]	 = new String[kd_size+1];
	car_kd_nm[0] = "����";
	car_kd_nm[1] = "����";
	car_kd_nm[2] = "����";
	car_kd_nm[3] = "��Ÿ";
	car_kd_nm[4] = "�Ұ�";
	
	
	String br_id_nm[]	 = new String[br_size];
	String br_id_cd[]	 = new String[br_size];
	
	if(brch_size > 0){
    		for (int i = 0 ; i < brch_size ; i++){
    			Hashtable branch = (Hashtable)branches.elementAt(i);
    			
    			br_id_nm[i] = String.valueOf(branch.get("BR_NM"));
    			br_id_cd[i] = String.valueOf(branch.get("BR_ID"));
    		}
    	}	
	
	
	int cnt1[]	 	= new int[kd_size+1];					
	int amt0[]	 	= new int[kd_size+1];
	int amt1[]	 	= new int[kd_size+1];
	int amt2[]	 	= new int[kd_size+1];


	int h_cnt1[]	 	= new int[br_size];
	int h_amt0[]	 	= new int[br_size];
	int h_amt1[]	 	= new int[br_size];
	int h_amt2[]	 	= new int[br_size];

	int t_cnt1[]	 	= new int[kd_size+1];
	int t_amt0[]	 	= new int[kd_size+1];
	int t_amt1[]	 	= new int[kd_size+1];
	int t_amt2[]	 	= new int[kd_size+1];
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//���θ���Ʈ
	function view_stat3(s_br, s_br_nm, car_kd, car_kd_nm){
		window.open('rm_stat3_list.jsp?gubun4=<%=gubun4%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_br='+s_br+'&s_br_nm='+s_br_nm+'&car_kd='+car_kd+'&car_kd_nm='+car_kd_nm, "STAT3_LIST", "left=0, top=0, width=900, height=568, scrollbars=yes, status=yes, resize");
	}

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='start_dt' 		value='<%=start_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td align='right'>(�ݾױ���:���ް�)</td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="3" colspan="2" class=title>����</td>
                    <td colspan="5" class=title>����(��ȸ������)</td>
                </tr>
                <tr> 
                    <td rowspan="2" width=15% class=title>�Ǽ�</td>
                    <td rowspan="2" width=15% class=title>����</td>
                    <td colspan="3" class=title>����(�������)</td>					
                </tr>                
                <tr> 
                    <td width=15% class=title>����</td>
                    <td width=15% class=title>�̵���</td>				
                    <td width=15% class=title>�հ�</td>
                </tr>  
                
                <!--������-->
		<%	for(int k = 0 ; k < br_size ; k++){
                		//�Ұ� �ʱ�ȭ
                		h_cnt1[k] = 0;                		
                		h_amt0[k] = 0;
                		h_amt1[k] = 0;
                		h_amt2[k] = 0;                		
		%>
		
                <%
                		//�׸� �ʱ�ȭ
                		for (int j = 0 ; j < kd_size ; j++){
					cnt1[j] = 0;
					amt0[j] = 0;
					amt1[j] = 0;
					amt2[j] = 0;
				}
                %>  	  		
		                
		<!--����,�λ�,����,����,�뱸,����,��õ,����-->
		<%		Vector vt = rs_db.getRmRentStat3List(br_id_cd[k], gubun4, start_dt, end_dt);
				int vt_size = vt.size();			
		%>
		<%		//�迭�� �� �ѱ�	
				for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					//����			
					if(String.valueOf(ht.get("CAR_KD")).equals("1")){													
						cnt1[0] = AddUtil.parseInt((String)ht.get("CNT1"));
						amt0[0] = AddUtil.parseInt((String)ht.get("AMT0"));
						amt1[0] = AddUtil.parseInt((String)ht.get("AMT1_1"));
						amt2[0] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					}						
					//����	
					if(String.valueOf(ht.get("CAR_KD")).equals("2")){
						cnt1[1] = AddUtil.parseInt((String)ht.get("CNT1"));
						amt0[1] = AddUtil.parseInt((String)ht.get("AMT0"));
						amt1[1] = AddUtil.parseInt((String)ht.get("AMT1_1"));
						amt2[1] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					}
					//����
					if(String.valueOf(ht.get("CAR_KD")).equals("3")){
						cnt1[2] = AddUtil.parseInt((String)ht.get("CNT1"));
						amt0[2] = AddUtil.parseInt((String)ht.get("AMT0"));
						amt1[2] = AddUtil.parseInt((String)ht.get("AMT1_1"));
						amt2[2] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					}
					//��Ÿ
					if(String.valueOf(ht.get("CAR_KD")).equals("4")){
						cnt1[3] = AddUtil.parseInt((String)ht.get("CNT1"));
						amt0[3] = AddUtil.parseInt((String)ht.get("AMT0"));
						amt1[3] = AddUtil.parseInt((String)ht.get("AMT1_1"));
						amt2[3] = AddUtil.parseInt((String)ht.get("AMT1_2"));
					}			
				}
		%>
					                
                <%		for(int i = 0 ; i < kd_size ; i++){
	                		//�Ұ�,�հ�
	                		h_cnt1[k] = h_cnt1[k]+cnt1[i];
        	        		h_amt0[k] = h_amt0[k]+amt0[i];
                			h_amt1[k] = h_amt1[k]+amt1[i];
                			h_amt2[k] = h_amt2[k]+amt2[i];
                			t_cnt1[i] = t_cnt1[i]+cnt1[i];
	                		t_amt0[i] = t_amt0[i]+amt0[i];
        	        		t_amt1[i] = t_amt1[i]+amt1[i];
                			t_amt2[i] = t_amt2[i]+amt2[i];
                %>           
                <!--����,����,����,��Ÿ-->
                <tr> 
                    <%if(i==0){%><td align='center' rowspan='5'><%=br_id_nm[k]%></td><%}%>
                    <td align='center'><%=car_kd_nm[i]%></td>
                    <td align='center'><a href="javascript:view_stat3('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','<%=i+1%>','<%=car_kd_nm[i]%>')"><%=cnt1[i]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt0[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt1[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt2[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(amt1[i]+amt2[i])%></td>
                </tr>   
                <%		}%> 
                <!--�Ұ�-->	                		                                    				
                <tr>                     
                    <td align='center'><%=car_kd_nm[4]%></td>
                    <td align='center'><a href="javascript:view_stat3('<%=br_id_cd[k]%>','<%=br_id_nm[k]%>','','')"><%=h_cnt1[k]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt0[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt1[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt2[k])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(h_amt1[k]+h_amt2[k])%></td>
                </tr>  
                
		<%	}%>
                
                

                                
		<!--�հ�--> 
		
                <%	for(int i = 0 ; i < kd_size ; i++){
                		t_cnt1[4] = t_cnt1[4]+t_cnt1[i];
                		t_amt0[4] = t_amt0[4]+t_amt0[i];
                		t_amt1[4] = t_amt1[4]+t_amt1[i];
                		t_amt2[4] = t_amt2[4]+t_amt2[i];
                %>           
                <tr> 
                    <%if(i==0){%><td align='center' rowspan='5'>�հ�</td><%}%>
                    <td align='center'><%=car_kd_nm[i]%></td>
                    <td align='center'><a href="javascript:view_stat3('','','<%=i+1%>','<%=car_kd_nm[i]%>')"><%=t_cnt1[i]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt0[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt2[i])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[i]+t_amt2[i])%></td>
                </tr>   
                <%	}%> 	                		                                    				
                <tr>                     
                    <td align='center'><%=car_kd_nm[4]%></td>
                    <td align='center'><a href="javascript:view_stat3('','','','')"><%=t_cnt1[4]%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt0[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt2[4])%></td>
                    <td align='right'><%=AddUtil.parseDecimal(t_amt1[4]+t_amt2[4])%></td>
                </tr>  		               	                                             

            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>