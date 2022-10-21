<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*, acar.util.*, acar.offls_cmplt.*"%>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")		==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")		==null?"":request.getParameter("gubun3");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	
	String dt	= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");

	
	Vector jarr = olcD.getCmplt_stat_lst(dt, ref_dt1, ref_dt2, gubun, gubun1, gubun2, gubun3, gubun_nm, br_id, s_au);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
	String jobjString = "";
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt5 = 0;
	long total_amt7 = 0;
	long total_amt10 = 0;	
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	
	long out_amt = 0;
	long comm2_tot	=0;
	
	//����縮������������� ���ϱ�
	float use_per1 = 0;
	float use_per2 = 0;
	float use_per3 = 0;
	float use_per4 = 0;
	
	float use_cnt1 = 0;
	float use_cnt2 = 0;
	float use_cnt3 = 0;
	float use_cnt4 = 0;
	
	float avg_per1 = 0;
	float avg_per2 = 0;
	float avg_per3 = 0;
	float avg_per4 = 0;
	
	int k =  0;
		
	if(jarr_size >= 0 ) {
		
		jobjString = "data={ rows:[ ";

		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
						
			if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 60500){
				comm2_tot 	= AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
				total_amt7	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
			}else{
				out_amt = AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
				total_amt10	= total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
			}
						
			float use_per = AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_PER")),2));
						
			if(String.valueOf(ht.get("CLIENT_ID")).equals("000502")){//��ȭ-����۷κ�(��)
				use_cnt1++;
				use_per1 = use_per1 + use_per;
			}else if(String.valueOf(ht.get("CLIENT_ID")).equals("013011")){//�д�-����۷κ�(��)
				use_cnt2++;
				use_per2 = use_per2 + use_per;
			}else if(String.valueOf(ht.get("CLIENT_ID")).equals("022846")){//��ȭ����ũ 013222-> 20150515 (��)����Ƽ��Ż 022846
				use_cnt3++;
				use_per3 = use_per3 + use_per;
			}else if(String.valueOf(ht.get("CLIENT_ID")).equals("011723")||String.valueOf(ht.get("CLIENT_ID")).equals("020385")){//(��)�����ڵ������ -> �������̼�ī �ֽ�ȸ��
				use_cnt4++;
				use_per4 = use_per4 + use_per;
			}
			avg_per1 = avg_per1 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_PER")),2));
			avg_per2 = avg_per2 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_F_PER")),2));
			avg_per3 = avg_per3 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_PER")),2));
			avg_per4 = avg_per4 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("ABS_HP_S_CHA_PER")),2));
						
			if(i != 0 ){
				jobjString += ",";
			}	
			k =  i+1;
	 	 	jobjString +=  " { id:" + k + ",";
	 	 	jobjString +=  "data:[\""  +  k + "\",";//����0
	 	 	jobjString +=  "\"" +ht.get("CAR_NO") +"^javascript:view_detail(&#39;"+ht.get("CAR_MNG_ID")+"&#39;, &#39;"+ht.get("SEQ")+"&#39;);^_self\",";//������ȣ 1
			jobjString +=  "\"" +String.valueOf(ht.get("CAR_NM")) + "\",";//����2
	 	 	jobjString +=  "\""+String.valueOf(ht.get("FIRM_NM"))+ht.get("ACTN_WH") + "\",";//�����3
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT"))) + "\",";//�������4
	 	 	jobjString +=  "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))  + "\",";//���ʵ����5
	 	 	jobjString +=  "\""+String.valueOf(ht.get("CAR_C_AMT")) + "\",";//�Һ��ڰ���6
	 	 	jobjString +=  "\""+String.valueOf(ht.get("CAR_F_AMT")) + "\",";//���԰���7
	 	 	jobjString += "\""+ String.valueOf(ht.get("HP_PR")) + "\",";//�����8
	 	 	jobjString += "\""+ String.valueOf(ht.get("CAR_S_AMT")) + "\",";//��������9
	 	 	jobjString += "\""+ String.valueOf(ht.get("NAK_PR")) + "\",";//������10
	 	 	jobjString +=  "\""+String.valueOf(ht.get("HP_C_PER")) + "\",";//�Һ��ڰ� ���11
	 		jobjString += "\""+String.valueOf(ht.get("HP_F_PER")) + "\",";//���԰� ���12
	 	 	jobjString += "\""+String.valueOf(ht.get("HP_S_PER")) + "\",";//�������� ���13
	 		jobjString +=  "\""+String.valueOf(ht.get("HP_S_CHA_AMT")) + "\",";//�����ݾ�14
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_CHA_PER")),2) + "\",";//����%(�������� ����)15
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_CHA_PER")),2) + "\",";//����%(�Һ��ڰ� ����)16
	 		jobjString +=  "\""+ht.get("CAR_OLD_MONS") + "\",";//����17
	 		jobjString +=  "\""+String.valueOf(ht.get("KM")) + "\",";//����Ÿ�18
	 		jobjString +=  "\""+ht.get("ACTN_JUM") + "\",";//����� ����19
	 		jobjString +=  "\""+ht.get("PARK_NM") + "\",";//������ ��ġ20
	 		jobjString +=  "\""+ht.get("ACCID_YN") + "\",";//�������21
	 		jobjString +=  "\""+String.valueOf(ht.get("HAP_AMT")) + "\",";//�������� - �����ݾ�22
	 		jobjString +=  "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("SE_PER")),2)+"\",";//�������� - �Һ��ڰ� ���23
	 		jobjString +=  "\""+String.valueOf(ht.get("COMM1_TOT")) + "\",";//�Ű������� - ����������24
	 		jobjString +=  "\""+comm2_tot + "\",";//�Ű������� - ��ǰ������25
	 		jobjString +=  "\""+String.valueOf(out_amt) + "\",";//�Ű������� - ����ǰ������26
	 		jobjString +=  "\""+String.valueOf(ht.get("COMM3_TOT")) + "\",";//�Ű������� - ����Ź�۴��27
	 		//jobjString +=  ",";//�Ű������� - �հ�28 : �׸��� ��ü �������� �հ� ���
	 		jobjString +=  "\""+String.valueOf(ht.get("COMM_TOT")) + "\",";//�Ű������� - �հ�28
	 		jobjString +=  "\""+String.valueOf(ht.get("SUI_NM")) + "\",";//������29
	 		jobjString += "\""+String.valueOf(ht.get("OPT")) + "\",";//���û��30
	 		jobjString += "\""+ht.get("OPT_AMT") + "\",";//���û�簡31
	 		jobjString += "\""+ ht.get("DPM") + "\",";//��ⷮ32
	 		jobjString += "\""+ ht.get("FUEL_KD") + "\",";//����33
	 		jobjString += "\""+ String.valueOf(ht.get("COLO")) + "\",";//����34
	 		jobjString += "\""+ String.valueOf(ht.get("IN_COL")) + "\",";//�������35
	 		jobjString += "\""+ ht.get("JG_CODE") + "\"]";//�����ڵ�36
	 		
	 	 	jobjString += "}";
		}	
		jobjString += "]};";
	} 
	
%>

<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<!--link rel=stylesheet type="text/css" href="/include/table.css"-->

<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body {height: 93%;	}
	input.whitenum {text-align: right;  border-width: 0; }
</style>
<!--Grid-->

<script>
<%=jobjString%>

function view_detail(car_mng_id, seq)
{
	var fm = document.form1;
	fm.car_mng_id.value = car_mng_id;
	fm.seq.value = seq;
	fm.target = "d_content";
	fm.action = "/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp";
	fm.submit();
}

var myGrid;

function parsingGridData(){
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("");//��0-36��(37��)
	myGrid.setHeader("����,������ȣ,����,�����,�������,���ʵ����,�Һ��ڰ���,���԰���,�����,��������,�Ű�(����),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,����,����<br>�Ÿ�,�����<br>����,��������ġ,���<br>����,��������,#cspan,�Ű�������,#cspan,#cspan,#cspan,#cspan,������,���û��,���û�簡,��ⷮ,����,����,�������,�����ڵ�");
	myGrid.setInitWidths("35,70,150,90,80,80,105,105,95,90,90,100,70,70,90,85,75,55,65,60,80,50,95,70,85,55,85,80,85,100,170,90,70,50,90,80,70");
	myGrid.setColSorting("int,str,str,str,str,str,int,int,int,int,int,int,int,int,int,int,int,int,int,str,str,str,int,int,int,int,int,int,int,str,str,int,int,str,str,str,int");
	myGrid.setColTypes("ro,link,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ro,ro,ro,ron");
	myGrid.attachHeader("#rspan,#text_filter,#text_filter,#select_filter,#select_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,������,�Һ��ڰ�<br>���,���԰�<br>���,����<br>������<br>���,�����ݾ�,����%<br>(��������<br>����),����%<br>(�Һ��ڰ�<br>����),#rspan,#rspan,#rspan,#select_filter,#select_filter,�����ݾ�,�Һ��ڰ�<br>���,����<br>������,��ǰ<br>������,����ǰ<br>������,����<br>Ź�۴��,�հ�,#text_filter,#text_filter,#rspan,#rspan,#select_filter,#text_filter,#select_filter,#select_filter");
	myGrid.setColAlign("center,center,center,center,center,center,right,right,right,right,right,right,right,right,right,right,right,center,right,center,center,center,right,right,right,right,right,right,right,center,center,right,center,center,center,center,center");
	myGrid.enableTooltips("false,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,false,false,false,true,false,false");
	myGrid.setNumberFormat("0,000",6);
	myGrid.setNumberFormat("0,000",7);
	myGrid.setNumberFormat("0,000",8);
	myGrid.setNumberFormat("0,000",9);
	myGrid.setNumberFormat("0,000",10);
	myGrid.setNumberFormat("0,000.00%",11);
	myGrid.setNumberFormat("0,000.00%",12);
	myGrid.setNumberFormat("0,000.00%",13);
	myGrid.setNumberFormat("0,000",14);
	myGrid.setNumberFormat("0,000.00%",15);
	myGrid.setNumberFormat("0,000.00%",16);
	myGrid.setNumberFormat("0,000",18);
	myGrid.setNumberFormat("0,000",22);
	myGrid.setNumberFormat("0,000.00%",23);
	myGrid.setNumberFormat("0,000",24);
	myGrid.setNumberFormat("0,000",25);
	myGrid.setNumberFormat("0,000",26);
	myGrid.setNumberFormat("0,000",27);
	myGrid.setNumberFormat("0,000",28);
	myGrid.setNumberFormat("0,000",31);
	
	myGrid.attachEvent("onXLE",function(){  
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			alert('�ش� ������ �����ϴ�');
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});	
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,�հ�,#cspan,#cspan,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,,#stat_cha_total,,,,,,,,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,���(��ձݾ� �� ��ձݾ����� ���),#cspan,#cspan,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,{#stat_multi_total_avg}6:10,{#stat_multi_total_avg}7:10,{#stat_multi_total_avg}9:10,#stat_cha_average,{#stat_multi_total_avg_cha}9:14,{#stat_multi_total_avg_cha}6:14,,,,,,#stat_average,{#stat_multi_total_avg}6:22,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,,,#stat_average,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ���밪 �ݿ�,#cspan,#cspan,���(������� ���),#cspan,#cspan,,,,,,#stat_average,#stat_average,#stat_average,,#stat_cha_average,#stat_cha_average,,,,,,,#stat_average,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,�հ�,#cspan,#cspan,,,,,,,,,#stat_total,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,���(��ձݾ� �� ��ձݾ����� ���),#cspan,#cspan,,,,,,,,,#stat_average,{#stat_multi_total_avg}9:14,{#stat_multi_total_avg}6:14,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("���� ��ȣ �ݿ�,#cspan,#cspan,���(������� ���),#cspan,#cspan,,,,,,,,,,#stat_average,#stat_average,#stat_average,#stat_average,,,,,,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.splitAt(6);
	//myGrid.enableBlockSelection();
    myGrid.enableMathEditing(true);
    myGrid.enableColumnMove(true);      
    myGrid.enableSmartRendering(true);
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.parse(data,"json");	   

}

function onKeyPressed(code,ctrl,shift){
	if(code==67&&ctrl){
		if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
			myGrid.setCSVDelimiter("\t");
			
			myGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			myGrid.setCSVDelimiter("\t");
			myGrid.pasteBlockFromClipboard()
		}
	return true;
}

</script>

</head>
<body leftmargin="15" onload="javascript:parsingGridData();">
<form name='form1' method='post' target='d_content' action='/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'> 
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun_nm' value='<%=gubun_nm%>'>
<input type='hidden' name='dt' value='<%=dt%>'>
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'>
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
<input type='hidden' name='s_au' value='<%=s_au%>'>
<input type='hidden' name='from_page' value='/acar/off_ls_cmplt/off_ls_stat_grid_sc_old.jsp'>  
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='seq' value=''>


<table border="0" cellspacing="0" cellpadding="0" width=100% height="35px">
	<tr>
		<td align=''>
		<!--input type="button" value="Excel" onclick=";"-->
		<a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
    <tr> 
        <td align="right" style="margin-right:5px; font-size: 9pt;">
            * ��� �������������:
              [����۷κ�-��ȭ]	<input type='text' name='avg_per1' size='4' class='whitenum'>%&nbsp;
              [����۷κ�-�д�]	<input type='text' name='avg_per2' size='4' class='whitenum'>%&nbsp;
	      	  [�������̼�ī �ֽ�ȸ��]	<input type='text' name='avg_per4' size='4' class='whitenum'>%&nbsp;		
              [�Ե���Ż]		<input type='text' name='avg_per3' size='4' class='whitenum'>%&nbsp;          
        </td>
    </tr>
</table>
</form>
<!--   
    <tr>
    	<td> -->
    		<div id="gridbox" style="width:100%;height:100%; margin: 5px 0 5px 0;"></div>
    	<!-- </td>
    </tr> -->
<table border="0" cellspacing="0" cellpadding="0" width=100% height="25px">
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;">
            * �� �Ǽ� : <span id="gridRowCount">0</span>�� 
        </td>
        <td width="10%">
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td width="80%" align="right" style="font-size: 9pt;">
        	<span>* �������� : 20150512 �������� �縮��������, 20150512 ���ʹ� �������� ��갪</span>
        </td>
    </tr>    
</table>
<script language='javascript'>
<!--
	document.form1.avg_per1.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per1/use_cnt1), 2)%>';
	document.form1.avg_per2.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per2/use_cnt2), 2)%>';
	document.form1.avg_per3.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per3/use_cnt3), 2)%>';
	document.form1.avg_per4.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per4/use_cnt4), 2)%>';
//-->
</script>
</body>
</html>