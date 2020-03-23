package com.hjapp.ui.activity;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;


/**
 * @Author: yuhaocan
 * @CreateDate: 2019-10-15
 */
public class WebActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView textView = new TextView(this);
        textView.setText("This is Natvie Page");
        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.addView(textView);

        Button button = new Button(this);
        button.setText("finis");
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        linearLayout.addView(button);
        setContentView(linearLayout);
    }
}
